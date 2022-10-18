--liquibase formatted sql
--changeset HugoDorne:1 Création des tables
CREATE TABLE person
(
    id         bigint,
    firstname  varchar NOT NULL,
    lastname   varchar NOT NULL,
    birth_date date,
    PRIMARY KEY (id)
);

CREATE TABLE "user"
(
    id           bigint,
    person_id    bigint  NOT NULL,
    login        varchar NOT NULL,
    password     varchar NOT NULL,
    email        varchar NOT NULL,
    phone_number varchar,
    PRIMARY KEY (id),
    CONSTRAINT "FK_User.person_id"
        FOREIGN KEY (person_id)
            REFERENCES person (id)
);

CREATE TABLE author
(
    id         bigint,
    person_id  bigint NOT NULL,
    death_date date,
    PRIMARY KEY (id),
    CONSTRAINT "FK_Author.person_id"
        FOREIGN KEY (person_id)
            REFERENCES person (id)
);

CREATE TABLE editor
(
    id   bigint,
    name varchar NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE collection
(
    id        bigint,
    editor_id bigint  NOT NULL,
    name      varchar NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT "FK_Collection.editor_id"
        FOREIGN KEY (editor_id)
            REFERENCES editor (id)
);

CREATE TABLE book
(
    isbn            bigint,
    author_id       bigint  NOT NULL,
    editor_id       bigint  NOT NULL,
    collection_id   bigint,
    title           varchar NOT NULL,
    description     varchar,
    release_date    date    NOT NULL,
    number_of_pages int     NOT NULL,
    PRIMARY KEY (isbn),
    CONSTRAINT "FK_Book.author_id"
        FOREIGN KEY (author_id)
            REFERENCES author (id),
    CONSTRAINT "FK_Book.editor_id"
        FOREIGN KEY (editor_id)
            REFERENCES editor (id),
    CONSTRAINT "FK_Book.collection_id"
        FOREIGN KEY (collection_id)
            REFERENCES collection (id)
);

CREATE TABLE reading_list
(
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    CONSTRAINT "FK_ReadingList.user_id"
        FOREIGN KEY (user_id)
            REFERENCES "user" (id),
    CONSTRAINT "FK_ReadingList.book_id"
        FOREIGN KEY (book_id)
            REFERENCES book (isbn),
    PRIMARY KEY (user_id, book_id)
);

CREATE TABLE admin
(
    id      bigint,
    user_id bigint NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT "FK_Admin.user_id"
        FOREIGN KEY (user_id)
            REFERENCES "user" (id)
);

CREATE TABLE book_condition
(
    state varchar NOT NULL,
    PRIMARY KEY (state)
);

CREATE TABLE library_book
(
    id                bigint,
    book_id           bigint  NOT NULL,
    is_available      boolean NOT NULL,
    registration_date date    NOT NULL,
    condition         varchar NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT" FK_LibraryBook.book_id"
        FOREIGN KEY (book_id)
            REFERENCES book (isbn),
    CONSTRAINT "FK_LibraryBook.condition"
        FOREIGN KEY (condition)
            REFERENCES book_condition (state)
);

CREATE TABLE borrow_status
(
    status varchar NOT NULL,
    PRIMARY KEY (status)
);

CREATE TABLE borrow
(
    id             bigint,
    user_id        bigint      NOT NULL,
    librarybook_id bigint      NOT NULL,
    start_date     timestamptz NOT NULL,
    end_date       timestamptz NOT NULL,
    return_date   timestamptz,
    status         varchar     NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT "FK_Borrow.librarybook_id"
        FOREIGN KEY (librarybook_id)
            REFERENCES library_book (id),
    CONSTRAINT "FK_Borrow.user_id"
        FOREIGN KEY (user_id)
            REFERENCES "user" (id),
    CONSTRAINT "FK_Borrow.status"
        FOREIGN KEY (status)
            REFERENCES borrow_status (status)
);

CREATE TABLE genre
(
    name varchar NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE book_genres
(
    book_id  bigint NOT NULL,
    genre varchar NOT NULL,
    CONSTRAINT "FK_BookGenres.book_id"
        FOREIGN KEY (book_id)
            REFERENCES book (isbn),
    CONSTRAINT "FK_BookGenres.genre_id"
        FOREIGN KEY (genre)
            REFERENCES genre (name),
    PRIMARY KEY (genre, book_id)
);
