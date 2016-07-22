# This file will be loaded if the current extension is the
# one controlling Lanes.
#
# It will not be evaluated if another extension is loading this one
Lanes.configure do | config |


end

secrets = Pathname.new(__FILE__).dirname.join('secrets.rb')
if secrets.exist?
    require secrets
end
