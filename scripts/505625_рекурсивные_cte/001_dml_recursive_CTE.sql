CREATE TABLE folders (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id BIGINT REFERENCES folders(id)
);

INSERT INTO folders (name, parent_id)
VALUES ('Projects', NULL),
       ('Backend', 1),
       ('Frontend', 1),
       ('Java', 2),
       ('Python', 2),
       ('src', 4),
       ('test', 4),
       ('React', 3),
       ('components', 8),
       ('utils', 9),
       ('images', 8);

UPDATE folders
SET parent_id = 10
WHERE id = 3;

WITH RECURSIVE folders_three AS (
SELECT
	id,
	name,
	parent_id,
	1 AS level,
	name::text AS tree_path
FROM folders
WHERE id = 1
UNION ALL
SELECT
	f.id,
	f.name,
	f.parent_id,
	ft."level"  + 1,
	ft.tree_path || ' -> ' || f."name"
FROM folders	 f
JOIN folders_three ft ON f.parent_id = ft.id
)
SELECT
	repeat('		', "level" - 1) || name AS folder_name,
	"level"
FROM folders_three
ORDER BY tree_path;

WITH RECURSIVE folders_three AS (
SELECT
	id,
	name,
	parent_id,
	ARRAY[name] AS path
FROM folders
WHERE id = 10
UNION ALL
SELECT
	f.id,
	f.name,
	f.parent_id,
	f."name" || ft.path
FROM folders	 f
JOIN folders_three ft ON f.id = ft.parent_id
)
SELECT
	array_to_string(path, ' -> ') AS full_path
FROM folders_three
WHERE parent_id IS NULL;

WITH RECURSIVE folders_three AS (
SELECT
	id,
	name,
	parent_id,
	1 AS level,
	name::text AS tree_path
FROM folders
WHERE id = 1
UNION ALL
SELECT
	f.id,
	f.name,
	f.parent_id,
	ft."level"  + 1,
	ft.tree_path || ' -> ' || f."name"
FROM folders	 f
JOIN folders_three ft ON f.parent_id = ft.id
)
CYCLE id
SET is_cycle
USING cycle_path
SELECT
	repeat('		', "level" - 1) || name AS folder_name,
	"level"
FROM folders_three
WHERE is_cycle = false
ORDER BY tree_path;