require "rubygems"
require "bundler"

Bundler.require

require "dotenv/load"
require "uri"

desc "Loads all files from FTP and dumps the DP"
task backup: [:ftp, :db, :commit]

task :ftp do
  ftp.pull_dir "backup", "/" + @path, since: true, skip_errors: true
end

task :db do
  dump_db
end

task :commit do
  commit
end

def ftp
  @ftp ||= begin
    url = URI(ENV["FTP"])
    user, password, host, @path = [:user, :password, :host, :path].map { |e| url.send(e) }
    ftp = FtpSync.new host, user, password
  end
end

def sh(command)
  error "could not execute '#{command}'" unless system(command)
end

def dump_db
  sh "ssh #{ENV['SSH_HOST']} \"#{dump_command} | gzip -c\" | gunzip > backup/db.sql"
end

def dump_command
  uri = URI.parse ENV["DATABASE_URL"]
  db_name = uri.path.sub("/", "").freeze
  args = [
    "mysqldump",
    "--databases", db_name,
    "--quote-names",
    "--host", uri.host,
    "-p#{uri.password}",
    "--user", uri.user,
    "--lock-tables=false"
  ]
  args.join(" ")
end

def commit
  sh "cd backup && git init && git add . && git commit -m 'backup at #{Time.now}' --allow-empty"
end
