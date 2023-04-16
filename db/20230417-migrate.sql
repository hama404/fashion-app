DROP IF EXISTS TABLE Items;

CREATE TABLE IF NOT EXISTS Tags (
    id integer NOT NULL,
    name varchar(32),
    PRIMARY KEY (id)
);

INSERT INTO Tags (id, name)
    VALUES 
        (1, "Web URL"),
        (2, "Youtube"),
        (3, "Youtube Plalist");

CREATE TABLE IF NOT EXISTS Bookmarks (
    id integer AUTO_INCREMENT NOT NULL,
    url text NOT NULL,
    title varchar(32),
    description varchar(256), 
    tag_id integer,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);
