CREATE TABLE courses
(
    id          BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(255),
    description VARCHAR(255),
    created_at  TIMESTAMP,
    updated_at  TIMESTAMP,
    is_deleted  BOOLEAN DEFAULT FALSE
);

CREATE TABLE lessons
(
    id                 BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_id          BIGINT REFERENCES courses (id),
    name               VARCHAR(255),
    content            TEXT,
    link_on_video      VARCHAR(255),
    position_in_course SMALLINT,
    created_at         TIMESTAMP,
    updated_at         TIMESTAMP,
    is_deleted         BOOLEAN DEFAULT FALSE
);

CREATE TABLE programs
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name       VARCHAR(255),
    cost       NUMERIC(2),
    type_id    INTEGER,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE modules
(
    id          BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    program_id  BIGINT REFERENCES programs (id),
    name        VARCHAR(255),
    description VARCHAR(255),
    created_at  TIMESTAMP,
    updated_at  TIMESTAMP
);

CREATE TABLE modules_courses
(
    id        BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    module_id BIGINT REFERENCES modules (id),
    course_id BIGINT REFERENCES courses (id)
)