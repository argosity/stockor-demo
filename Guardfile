require "lanes/guard_tasks"

Lanes::GuardTasks.run(self, name: "stockor-demo-access") do | tests |

    tests.client do

    end

    tests.server do

    end
#%r{../lanes/client/lanes/.*\.(js|coffee|cjsx)$}
    tests.hot_reload do

        #watch('../lanes/client/lanes/access/LoginDialog.cjsx')
    end
end
