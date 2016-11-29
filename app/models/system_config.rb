class SystemConfig < ApplicationRecord
  has_many :system_config_apps
  has_many :apps, through: :system_config_apps
  belongs_to :user, class_name: :'BasicUser'

  def contains?(app)
    self.apps.include?(app)
  end

  def call_action(action, app)
    case action
      when 'add'
        self.apps << app
      when 'remove'
        self.apps.delete(app.id)
    end
  end

  def build_script_and_package
    clean_up
    make_needed_dirs
    file = build_script
    if Rails.env.development? && ENV['create_platypus_app']
      # this happens in dev to create the template TabulaRasa/tabula-rasa
      build_package(file)
    else
      # In prod we have to use template because platypus doenst exist and work with linux distro on heroku.
      modify_template(file)
    end
  end

  def make_needed_dirs
    make_script_directory unless Dir.exists?(script_directory)
    make_zip_directory unless Dir.exists?(zip_location)
  end

  def clean_up
    system "rm #{zip_location}/#{zip_name}" if File.exists?("#{zip_location}/#{zip_name}")
    system "rm -rf #{script_directory}/#{pkg_created_name}" if Dir.exists?("#{script_directory}/#{pkg_created_name}")
    system "rm #{script_name}" if File.exists?("#{script_name}")
  end

  def script_name
    "#{script_directory}/#{self.user.id}-#{self.name.gsub(' ','-')}.sh"
  end

  def build_script
    out_file = File.new(script_name, "w")
    script = <<EOF
#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew

function runbrew {

export PATH=/usr/local/bin:$PATH

echo PROGRESS:0

local BREWPATH=$(which brew)
if test ! $BREWPATH
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# echo 'this is your path'
# echo $PATH
local BREWPATH=$(which brew)
# echo $BREWPATH
# Install Cask

echo "Installing Brew Cask to help install your Apps"
$BREWPATH install caskroom/cask/brew-cask

EOF
    how_many_apps = self.apps.count
    i = 0
    self.apps.each do |app|
      if i != 0
        progress = ((i.to_f / how_many_apps.to_f) * 100).to_i
      else
        progress = 0
      end
      script << "\n echo PROGRESS:#{progress}"
      script << "\n " + "echo 'Installing #{app.name} ' "
      script << "\n sleep 2"
      script << "\n $BREWPATH " + app.install_command
      i += 1
      if i == how_many_apps
        script << "\n echo PROGRESS:100"
        script << "\n echo 'ALERT: Installation Finished | All done here. :)'"
        script << "\n echo 'Task completed'"
      end
    end

    script << "\n } \n runbrew"
    out_file.puts(script)
    out_file.close
    @script = out_file
  end

  def make_zip_directory
    system "mkdir zips"
  end

  def zip_location
    'zips'
  end

  def pkg_created_name
    "tabula-rasa-#{self.id}"
  end

  def zip_name
    "#{pkg_created_name}.zip"
  end

  def make_script_directory
    system 'mkdir TabulaRasa'
  end

  def script_directory
    'TabulaRasa'
  end

  def app_name
    "#{pkg_created_name}.app"
  end

  def modify_template(file)
    system "cp -R TabulaRasa/tabula-rasa-template TabulaRasa/#{pkg_created_name}"
    system "mv TabulaRasa/#{pkg_created_name}/tabula-rasa-template.app TabulaRasa/#{pkg_created_name}/#{app_name}"
    system "mv #{file.path} TabulaRasa/#{pkg_created_name}/#{app_name}/Contents/Resources/script"
    system "zip -r #{zip_location}/#{zip_name} #{script_directory}/#{pkg_created_name}/#{app_name}"
    "#{zip_location}/#{zip_name}"
  end

  def build_package(file)
    # -b --text-background-color [hexColor]
    # For Text Window output mode only. Set background color of text out-
    #                                                                    put (e.g. #ffffff).
    #
    # -g --text-foreground-color [hexColor]
    # For Text Window output mode only. Set foreground color of text out-
    #                                                                    put (e.g. #000000).
    #
    # -n --text-font [fontName]
    # For Text Window output mode only. Set font and fontsize for text
    #                                                         output field (e.g. 'Monaco 10').
    system "mkdir #{script_directory}/#{pkg_created_name}"
    system "platypus -y -b '#000000' -g '#00FF00' -n 'Arial 12' -o 'Progress Bar' -a #{pkg_created_name} -i tabula-rasa-icon.icns -p /bin/sh #{file.path} #{script_directory}/#{pkg_created_name}/#{pkg_created_name}"
    system "zip -r #{zip_location}/#{zip_name} #{script_directory}/#{pkg_created_name}/#{app_name}"
    "#{zip_location}/#{zip_name}"
  end
end


# This is a simple example which uses rubyzip to
# recursively generate a zip file from the contents of
# a specified directory. The directory itself is not
# included in the archive, rather just its contents.
#
# Usage:
#   directoryToZip = "/tmp/input"
#   outputFile = "/tmp/out.zip"
#   zf = ZipFileGenerator.new(directoryToZip, outputFile)
#   zf.write()
class ZipFileGenerator

  # Initialize with the directory to zip and the location of the output archive.
  def initialize(inputDir, outputFile)
    @inputDir = inputDir
    @outputFile = outputFile
  end

  # Zip the input directory.
  def write()
    entries = Dir.entries(@inputDir); entries.delete("."); entries.delete("..")
    io = Zip::File.open(@outputFile, Zip::File::CREATE);

    writeEntries(entries, "", io)
    io.close();
  end

  # A helper method to make the recursion work.
  private
  def writeEntries(entries, path, io)

    entries.each { |e|
      zipFilePath = path == "" ? e : File.join(path, e)
      diskFilePath = File.join(@inputDir, zipFilePath)
      puts "Deflating " + diskFilePath
      if  File.directory?(diskFilePath)
        io.mkdir(zipFilePath)
        subdir =Dir.entries(diskFilePath); subdir.delete("."); subdir.delete("..")
        writeEntries(subdir, zipFilePath, io)
      else
        io.get_output_stream(zipFilePath) do |out|
          out.write File.binread(diskFilePath)
        end
        # io.get_output_stream(zipFilePath) { |f| f.puts(File.open(diskFilePath, "rb").read())}
      end
    }
  end

end
