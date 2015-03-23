tasks = Rake.application.instance_variable_get '@tasks'

# prevent from killing external DBs
str =<<-EOS
  test
  test:recent
  test:single
  test:uncommitted
  db:create
  db:drop
  db:fixtures:load
  db:migrate
  db:migrate:status 
  db:rollback
  db:schema:dump
  db:schema:load
  db:seed
  db:setup
  db:structure:dump 
  db:version
  EOS

str.split("\n").each do |t|
  tasks.delete t.strip
end
