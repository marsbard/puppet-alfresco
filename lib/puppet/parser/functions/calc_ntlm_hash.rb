require 'shellwords'

module Puppet::Parser::Functions
	newfunction(:calc_ntlm_hash, :type => :rvalue ) do |args|
		admin_pass = args[0]

		command = Shellwords.escape('iconv -f ASCII -t UTF-16LE <(printf "' << admin_pass << '") | openssl dgst -md4 | cut -f2 -d\ ')

		hash = `bash -c #{command}`

		return hash
	end
end
