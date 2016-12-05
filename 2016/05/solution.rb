require 'digest/md5'

input    = 'ojvtpuvg'
password = [nil] * 8
index    = 0

until password.all?
  hash = Digest::MD5.hexdigest(input + index.to_s)
  if hash =~ /^00000[0-7]/
    password[hash[5].to_i] ||= hash[6]
    p [hash, password]
  end
  index += 1
end

p password.join('')
