CREATE TABLE roles (
    id   INTEGER PRIMARY KEY,
    role TEXT UNIQUE,
    description TEXT
  );
  CREATE TABLE users (
    id       INTEGER PRIMARY KEY,
    username TEXT UNIQUE,
    email    TEXT,
    password TEXT,
    created_date TEXT,
    avatar TEXT,
    salt INTEGER
  );
  CREATE TABLE user_roles (
    user_id INTEGER REFERENCES users(id),
    role_id INTEGER REFERENCES roles(id),
    PRIMARY KEY(user_id, role_id)
  );
  CREATE TABLE topics (
    id INTEGER PRIMARY KEY,
    topic_name TEXT UNIQUE,
    description TEXT,
    category TEXT UNIQUE,
    created_date TEXT
  );
  CREATE TABLE threads (
    id INTEGER PRIMARY KEY,
    thread_subject TEXT UNIQUE,
    body TEXT,
    topic_id INTEGER REFERENCES topics(id),
    created_date TEXT,
    owner_id INTEGER REFERENCES users(id),
    image_path TEXT,
    is_activated BOOLEAN
  );
  CREATE TABLE posts (
    id INTEGER PRIMARY KEY,
    body TEXT,
    image_path TEXT,
    created_date TEXT,
    thread_id INTEGER REFERENCES threads(id),
    sender_id INTEGER REFERENCES users(id)
  );
  
