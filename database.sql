-- Step 1

CREATE TABLE courses
(
    id          BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(255),
    description VARCHAR(255),
    created_at  DATE,
    updated_at  DATE,
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
    created_at         DATE,
    updated_at         DATE,
    is_deleted         BOOLEAN DEFAULT FALSE
);

CREATE TABLE programs
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name       VARCHAR(255),
    cost       NUMERIC(2),
    type_id    INTEGER,
    created_at DATE,
    updated_at DATE
);

CREATE TABLE modules
(
    id          BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    program_id  BIGINT REFERENCES programs (id),
    name        VARCHAR(255),
    description VARCHAR(255),
    created_at  DATE,
    updated_at  DATE
);

CREATE TABLE modules_courses
(
    id        BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    module_id BIGINT REFERENCES modules (id),
    course_id BIGINT REFERENCES courses (id)
);

-- Step 2

CREATE TABLE teaching_groups
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slug       VARCHAR(255),
    created_at DATE,
    updated_at DATE
);

CREATE TYPE USER_ROLE AS ENUM ('student', 'teacher', 'admin');

CREATE TABLE users
(
    id                BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name              VARCHAR(255),
    email             VARCHAR(255),
    password_hash     VARCHAR(255),
    teaching_group_id BIGINT REFERENCES teaching_groups (id),
    role              USER_ROLE,
    created_at        DATE,
    updated_at        DATE
);

-- Step 3

CREATE TYPE ENROLLMENT_STATUS AS ENUM ('active', 'pending', 'cancelled', 'completed');

CREATE TABLE enrollments
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id    BIGINT REFERENCES users (id),
    program_id BIGINT REFERENCES programs (id),
    status     ENROLLMENT_STATUS,
    created_at DATE,
    updated_at DATE
);

CREATE TYPE PAYMENT_STATUS AS ENUM ('pending', 'paid', 'failed', 'refunded');

CREATE TABLE payments
(
    id             BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    enrollment_id  BIGINT REFERENCES enrollments (id),
    payment_amount NUMERIC(2),
    payment_status PAYMENT_STATUS,
    payment_date   DATE,
    created_at     DATE,
    updated_at     DATE
);

CREATE TABLE program_completions
(
    id                     BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id                BIGINT REFERENCES users (id),
    program_id             BIGINT REFERENCES programs (id),
    certificate_url        VARCHAR(255),
    certificate_issue_date DATE,
    created_at             DATE,
    updated_at             DATE
);
























