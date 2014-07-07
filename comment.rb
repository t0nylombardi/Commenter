# viitup/comment.rb
# $Id$

# don_comment/comment_rails.step5.rb
# $Id$

#!/usr/bin/env ruby
# comment_rails.rb
#

# These are the files without extensions that we want to comment
#
@known_files = [ 'config.ru',
                 'Gemfile',
                 'Rakefile' ]

# These are the rules for commenting different types of files
#
@rules = { :c    => { :test => '^\/\*\s+[filename]\s+\$Id',
                      :inject => "/* %s\n   $Id$ */\n" },
           :erb  => { :test => '^<%#\s+[filename]\s+\$Id',
                      :inject => "<%%#\n\t%s\n\t\t$Id$\n\n\tvariables:\n-%%>\n" },
           :hash => { :test => '^#\s+[filename]\s+#\s+\$Id',
                      :inject => "# %s\n# $Id$\n\n" },
           :rdoc => { :test => '^#--\s+[filename]\s+\$Id',
                      :inject => "#--\n   %s\n#   $Id$\n#++\n\n" }
         }

# Adds the correct comment to the beginning of the file.  The file's contents
# will already be in the @file_text variable.
#
def add_comment(filename, rule)
  open("#{filename}.new", 'w') { |newfile|
    newfile << sprintf(@rules[rule][:inject], file_name_in_application(filename))
    newfile << @file_text
  }
  File.rename(filename, "#{filename}.old")
  File.rename("#{filename}.new", filename)
  File.delete("#{filename}.old")
  list_file filename, 'commented'
end


# Returns true if the directory name passed to it exists.  It also sets up
# the @directory and @app_name variables if it does.
#
def choose_directory(string)
  begin
    Dir.chdir(string)
    @dir_name = Dir.pwd
    @app_name = @dir_name.sub(/\/$/,'').sub(/.*\//,'')
    @dir_prefix = @dir_name.sub(/#{@app_name}(\/)?$/,'')
  rescue SystemCallError
    return false
  end
  true
end

# Checks whether the specified file needs comments, and add them if so.
#
def examine_file(filename)
  rule = nil
  if filename =~ /\.rb$/
    if file_name_in_application(filename) =~ /^#{@app_name}\/app\//
      rule = :rdoc
    else
      rule = :hash
    end
  elsif filename =~ /\.(erb)$/
    rule = :erb
  elsif filename =~ /\.(css|scss|js|coffee)$/
    rule = :c
  elsif filename =~ /\.(yml)$/ || matches_known_file(filename)
    rule = :hash
  end
  rule = nil if file_name_in_application(filename) =~ /^#{@app_name}\/(doc|coverage|public|script)\//
  if rule
    if needs_comment? filename, rule
        #needs_comment_v2? filename
      add_comment filename, rule
    else
      list_file filename, 'no change'
    end
  else
    list_file filename
  end
end

# Returns the specified file name with the appication directory as the first element.
#
def file_name_in_application(filename)
  filename.sub(/^#{@dir_prefix}/, '')
end


# Lists a file name along with a status on a single line.
# File names are listed beginning with the application directory.
#
def list_file(filename, status='')
  status_text = (status && status.length > 1) ? status + ':' : '--'
  puts sprintf('\t %-20s %s', status_text, file_name_in_application(filename))
end

# Returns true if the specified filename matches one of the known files
# that we want to comment.
#
def matches_known_file(filename)
  @known_files.each do |known|
    return true if filename =~ /#{@app_name}\/#{known}$/
  end
  false
end

# Returns true if this file needs a comment added. As a side effect, the
# contents of the file are stored in the @file_text variable.
#
def needs_comment?(filename, rule)
  file = File.new(filename)
  @file_text = file.read
  file.close
  test = @rules[rule][:test].sub('[filename]',file_name_in_application(filename))
  if @file_text =~ Regexp.new(test)
    false
  else
    true
  end
end

# Returns true if the file already has comments. Returns false if there is no comments. 
#
def needs_comment_v2?(filename)
  string="$Id:"
 
  File.readlines(file).each do |line|
    if line.include?(string)
      true
    else
      false
    end
  end
    
end 


# Reads all the files in the chosen directory and comments each one.
#
def process_directory
  Dir.glob("#{@dir_name}/**/*").each do |file_name|
    if File.directory?(file_name)    # skip directories
      list_file file_name + '/'
    elsif file_name =~ /\$\$\$$|~$/  # skip backup files
      list_file file_name
    elsif !File.writable? file_name  # skip unwritable files
      list_file file_name, 'Unwritable'
    else
      examine_file file_name
    end
  end
end

# Main program
#
puts
if choose_directory(ARGV[0] || '.')
  if File.directory?('app/controllers')
    process_directory
  else
    puts "The directory '#{ARGV[0] || '.'}' doesn't look like a Rails application!"
  end
else
  puts "The directory '#{ARGV[0] || '.'}' doesn't seem to exist!"
end
