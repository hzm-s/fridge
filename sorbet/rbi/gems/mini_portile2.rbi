# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/mini_portile2/all/mini_portile2.rbi
#
# mini_portile2-2.5.3

class MiniPortile
  def activate; end
  def apply_patch(patch_file); end
  def archives_path; end
  def compile; end
  def computed_options; end
  def configure; end
  def configure_defaults; end
  def configure_options; end
  def configure_options=(arg0); end
  def configure_prefix; end
  def configured?; end
  def cook; end
  def detect_host; end
  def download; end
  def download_file(url, full_path, count = nil); end
  def download_file_file(uri, full_path); end
  def download_file_ftp(uri, full_path); end
  def download_file_http(url, full_path, count = nil); end
  def downloaded?; end
  def execute(action, command, command_opts = nil); end
  def extract; end
  def extract_file(file, target); end
  def files; end
  def files=(arg0); end
  def files_hashs; end
  def gcc_cmd; end
  def host; end
  def host=(arg0); end
  def initialize(name, version); end
  def install; end
  def installed?; end
  def log_file(action); end
  def logger; end
  def logger=(arg0); end
  def make_cmd; end
  def message(text); end
  def name; end
  def newer?(target, checkpoint); end
  def original_host; end
  def output(text = nil); end
  def patch; end
  def patch_files; end
  def patch_files=(arg0); end
  def path; end
  def port_path; end
  def self.mingw?; end
  def self.mswin?; end
  def self.windows?; end
  def tar_compression_switch(filename); end
  def tar_exe; end
  def target; end
  def target=(arg0); end
  def tmp_path; end
  def verify_file(file); end
  def version; end
  def which(cmd); end
  def with_tempfile(filename, full_path); end
  def work_path; end
end
class Net::HTTP < Net::Protocol
end
class MiniPortileCMake < MiniPortile
  def configure; end
  def configure_defaults; end
  def configure_prefix; end
  def configured?; end
  def make_cmd; end
end
