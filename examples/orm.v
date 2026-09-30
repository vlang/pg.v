// V's ORM on PostgreSQL, without the C libpq.
// usage: v -old-compiler -w run examples/orm.v
// (Connects to the server on localhost as postgres, port $PGPORT or 5432.)
import os
import pg

@[table: 'users']
struct User {
	id   int @[primary; sql: serial]
	name string
	age  int
}

fn main() {
	db := pg.connect(
		host:   'localhost'
		port:   (os.getenv_opt('PGPORT') or { '5432' }).int()
		user:   'postgres'
		dbname: 'postgres'
	)!
	defer {
		db.close() or {}
	}
	db.exec('drop table if exists users')!
	sql db {
		create table User
	}!
	for name, age in {
		'alice': 31
		'bob':   27
		'carol': 45
	} {
		user := User{
			name: name
			age:  age
		}
		sql db {
			insert user into User
		}!
	}
	older := sql db {
		select from User where age > 30 order by age
	}!
	for user in older {
		println('${user.id} ${user.name} ${user.age}')
	}
	rows := db.exec('select count(*), avg(age)::numeric(5,2) from users')!
	println(rows[0].vals)
	db.exec('drop table users')!
}
