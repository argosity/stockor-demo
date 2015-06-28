require 'lanes/access/user'

StockorDemo::ROLE_IDS.each do | role, id |
    role = role.to_s
    unless Lanes::User.exists?(id)
        u = Lanes::User.new( name: "#{role.camelize} Tester", email: "testing+#{role}@stockor.org",
          login: role, role_names: [role] )
        u.id = id
        u.password_confirmation = u.password = "password"
        u.save!
    end
end

max_id = StockorDemo::ROLE_IDS.values.max

if Lanes::User.connection.execute("select nextval('lanes_users_id_seq')").getvalue(0,0).to_i < max_id
    Lanes::User.connection.execute("select setval('lanes_users_id_seq',#{max_id})")
end
