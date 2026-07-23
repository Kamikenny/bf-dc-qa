CREATE TABLE users (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	username varchar(50) UNIQUE NOT NULL,
	email varchar(100) UNIQUE NOT NULL CHECK(email LIKE '%@%'),
	country varchar(50),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE profiles (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id int NOT NULL UNIQUE,
	bio text,
	avatar varchar(500),
	dob date,

	CONSTRAINT FK_user_id FOREIGN KEY(user_id)
	References users(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE publishers (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	name varchar(100) NOT NULL UNIQUE,
	country varchar(50)
);

CREATE TABLE games (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	title varchar(150) UNIQUE NOT NULL,
	price decimal(10, 2) NOT NULL CHECK(price >= 0),
	release_date date,
	publisher_id int,
	CONSTRAINT FK_publisher_id FOREIGN KEY(publisher_id)
	REFERENCES publishers(id)
	ON DELETE SET NULL
	ON UPDATE CASCADE
);

CREATE TABLE reviews (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id int,
	game_id int NOT NULL,
	rating int NOT NULL CHECK(rating BETWEEN 0 AND 5),
	comment varchar(1000) CHECK(LENGTH(comment) >= 2),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	CONSTRAINT FK_user_id FOREIGN KEY(user_id)
	References users(id)
	ON DELETE SET NULL
	ON UPDATE CASCADE,

	CONSTRAINT FK_game_id FOREIGN KEY(game_id)
	References games(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,

	UNIQUE(user_id, game_id)
);

CREATE TABLE user_games (
	id int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	user_id int,
	game_id int NOT NULL,
	hours_played int DEFAULT 0 CHECK(hours_played >= 10),
	purchased_date date NOT NULL DEFAULT NOW(),

	CONSTRAINT FK_user_id FOREIGN KEY(user_id)
	References users(id)
	ON DELETE SET NULL
	ON UPDATE CASCADE,

	CONSTRAINT FK_game_id FOREIGN KEY(game_id)
	References games(id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);