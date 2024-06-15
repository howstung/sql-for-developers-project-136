-- Step 1

CREATE TABLE courses
(
    id          BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(255) NOT NULL,
    description TEXT         NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted  BOOLEAN   DEFAULT FALSE
);

CREATE TABLE lessons
(
    id                 BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_id          BIGINT REFERENCES courses (id),
    name               VARCHAR(255) NOT NULL,
    body               TEXT         NOT NULL,
    video_url          VARCHAR(255),
    position_in_course SMALLINT     NOT NULL,
    created_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted         BOOLEAN   DEFAULT FALSE
);

CREATE TABLE programs
(
    id           BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name         VARCHAR(255)   NOT NULL,
    cost         NUMERIC(10, 2) NOT NULL,
    program_type VARCHAR(222)   NOT NULL, -- intensive, profession
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE modules
(
    id          BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name        VARCHAR(255) NOT NULL,
    description TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE program_modules
(
    program_id BIGINT REFERENCES programs (id),
    module_id  BIGINT REFERENCES modules (id),
    PRIMARY KEY (program_id, module_id)
);

CREATE TABLE module_courses
(
    module_id BIGINT REFERENCES modules (id),
    course_id BIGINT REFERENCES courses (id),
    PRIMARY KEY (module_id, course_id)
);

-- Step 2

CREATE TABLE teaching_groups
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    slug       VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users
(
    id                BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name              VARCHAR(255) NOT NULL,
    email             VARCHAR(255) NOT NULL UNIQUE,
    password_hash     VARCHAR(255) NOT NULL,
    teaching_group_id BIGINT REFERENCES teaching_groups (id),
    role              VARCHAR(20) CHECK (role IN ('student', 'teacher', 'admin')),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 3

CREATE TYPE ENROLLMENT_STATUS AS ENUM ('active', 'pending', 'cancelled', 'completed');

CREATE TABLE enrollments
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id    BIGINT REFERENCES users (id),
    program_id BIGINT REFERENCES programs (id),
    status     ENROLLMENT_STATUS,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE PAYMENT_STATUS AS ENUM ('pending', 'paid', 'failed', 'refunded');

CREATE TABLE payments
(
    id            BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    enrollment_id BIGINT REFERENCES enrollments (id),
    amount        NUMERIC(10, 2) NOT NULL,
    status        PAYMENT_STATUS NOT NULL,
    date          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE program_completions
(
    id                     BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id                BIGINT REFERENCES users (id),
    program_id             BIGINT REFERENCES programs (id),
    certificate_url        VARCHAR(255) DEFAULT NULL,
    certificate_issue_date TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    created_at             TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updated_at             TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Step 4

CREATE TABLE quizzes
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id  BIGINT REFERENCES lessons (id),
    name       VARCHAR(255) NOT NULL,
    body       JSON         NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE exercises
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id  BIGINT REFERENCES lessons (id),
    name       VARCHAR(255) NOT NULL,
    url        VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 5

CREATE TABLE discussions
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_id  BIGINT REFERENCES lessons (id),
    body       JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE ARTICLE_STATUS AS ENUM ('created', 'in moderation', 'published', 'archived');

CREATE TABLE blog
(
    id         BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id    BIGINT REFERENCES users (id),
    title      VARCHAR(255) NOT NULL,
    body       TEXT         NOT NULL,
    status     ARTICLE_STATUS,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);