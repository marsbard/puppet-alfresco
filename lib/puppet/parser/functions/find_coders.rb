require 'shellwords'

module Puppet::Parser::Functions
	newfunction(:find_coders, :type => :rvalue ) do |args|
		admin_pass = args[0]

		# WHAT WE WANT TO DO:
		#   In shell it is this:

		# find /usr -name jpeg.so  | grep coders | sed "s/\/jpeg.so$//"

		command = Shellwords.escape('find /usr -name jpeg.so  | grep coders | sed "s/\/jpeg.so$//" ')

		hash = `bash -c #{command}`
		
    return hash
	end
end
