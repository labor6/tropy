--
-- This file is auto-generated by executing all current
-- migrations. Instead of editing this file, please create
-- migrations to incrementally modify the database, and
-- then regenerate this schema file.
--
-- To create a new empty migration, run:
--   npm run db -- migration -- [name] [sql|js]
--
-- To re-generate this file, run:
--   npm run db -- migrate
--

-- Save the current migration number
PRAGMA user_version=1604261942;

-- Load sqlite3 .dump
PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE project (
  project_id  TEXT     NOT NULL PRIMARY KEY,
  name        TEXT     NOT NULL,
  settings             NOT NULL DEFAULT '{}',
  created_at  NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  opened_at   NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CHECK (project_id != ''),
  CHECK (name != '')
) WITHOUT ROWID;
CREATE TABLE subjects (
  sid          INTEGER  PRIMARY KEY,
  template_id  TEXT,
  created_at   NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE images (
  sid     INTEGER  PRIMARY KEY REFERENCES subjects ON DELETE CASCADE,
  width   INTEGER  NOT NULL DEFAULT 0,
  height  INTEGER  NOT NULL DEFAULT 0
) WITHOUT ROWID;
CREATE TABLE items (
  sid             INTEGER  PRIMARY KEY REFERENCES subjects ON DELETE CASCADE,
  cover_image_id  INTEGER  REFERENCES images ON DELETE SET NULL
) WITHOUT ROWID;
CREATE TABLE metadata_types (
  type_name    TEXT  NOT NULL PRIMARY KEY COLLATE NOCASE,
  type_schema  TEXT  NOT NULL UNIQUE,

  CHECK (type_schema != ''),
  CHECK (type_name != '')
) WITHOUT ROWID;
INSERT INTO "metadata_types" VALUES('boolean','https://schema.org/Boolean');
INSERT INTO "metadata_types" VALUES('location','https://schema.org/GeoCoordinates');
INSERT INTO "metadata_types" VALUES('number','https://schema.org/Number');
INSERT INTO "metadata_types" VALUES('text','https://schema.org/Text');
INSERT INTO "metadata_types" VALUES('datetime','https://schema.tropy.org/types/datetime');
INSERT INTO "metadata_types" VALUES('name','https://schema.tropy.org/types/name');
CREATE TABLE metadata (
  metadata_id  INTEGER  PRIMARY KEY,
  sid          INTEGER  NOT NULL REFERENCES subjects ON DELETE CASCADE,
  property_id  TEXT     NOT NULL,
  value_id     INTEGER  NOT NULL REFERENCES metadata_values,
  position     INTEGER  NOT NULL DEFAULT 0,

  UNIQUE (sid, position)
);
CREATE TABLE metadata_values (
  value_id  INTEGER  NOT NULL PRIMARY KEY,
  type_name TEXT     NOT NULL REFERENCES metadata_types
                       ON DELETE CASCADE ON UPDATE CASCADE,
  value              NOT NULL,
  struct             NOT NULL DEFAULT '{}',
  language  TEXT     REFERENCES languages,

  UNIQUE (type_name, value, language)
);
CREATE TABLE notes (
  note_id      INTEGER  PRIMARY KEY,
  sid          INTEGER  NOT NULL REFERENCES subjects ON DELETE CASCADE,
  position     INTEGER  NOT NULL DEFAULT 0,
  text         TEXT     NOT NULL,
  language     TEXT     NOT NULL DEFAULT 'en' REFERENCES languages,
  created_at   NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,

  UNIQUE (sid, position)
);
CREATE TABLE lists (
  list_id         INTEGER  PRIMARY KEY,
  name            TEXT     NOT NULL COLLATE NOCASE,
  parent_list_id  INTEGER  DEFAULT 0 REFERENCES lists ON DELETE CASCADE,
  position        INTEGER  NOT NULL DEFAULT 0,
  created_at      NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  deleted_at      NUMERIC,

  UNIQUE (parent_list_id, deleted_at, name),
  UNIQUE (parent_list_id, deleted_at, position)
);
INSERT INTO "lists" VALUES(0,'',NULL,0,'2016-09-26 20:23:34','2016-09-26 20:23:34',NULL);
CREATE TABLE list_items (
  sid      INTEGER REFERENCES items ON DELETE CASCADE,
  list_id  INTEGER REFERENCES lists ON DELETE CASCADE,
  position INTEGER NOT NULL DEFAULT 0,

  PRIMARY KEY (sid, list_id),
  UNIQUE (sid, list_id, position)
) WITHOUT ROWID;
CREATE TABLE tags (
  tag_name    TEXT     NOT NULL PRIMARY KEY COLLATE NOCASE,
  tag_color,
  created_at  NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CHECK (tag_name <> '')
) WITHOUT ROWID;
CREATE TABLE taggings (
  sid        INTEGER  NOT NULL REFERENCES subjects ON DELETE CASCADE,
  tag_name   TEXT     NOT NULL COLLATE NOCASE
                      REFERENCES tags ON DELETE CASCADE ON UPDATE CASCADE,
  tagged_at  NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (sid, tag_name)
) WITHOUT ROWID;
CREATE TABLE trash (
  sid         INTEGER  PRIMARY KEY REFERENCES subjects ON DELETE CASCADE,
  deleted_at  NUMERIC  NOT NULL DEFAULT CURRENT_TIMESTAMP
) WITHOUT ROWID;
CREATE TABLE photos (
  sid          INTEGER  PRIMARY KEY REFERENCES images ON DELETE CASCADE,
  item_id      INTEGER  NOT NULL REFERENCES items ON DELETE CASCADE,
  path         TEXT     NOT NULL,
  protocol     TEXT     NOT NULL DEFAULT 'file',
  mimetype     TEXT     NOT NULL,
  checksum     TEXT     NOT NULL,
  orientation  INTEGER  NOT NULL DEFAULT 1,
  exif                  NOT NULL DEFAULT '{}'
) WITHOUT ROWID;
CREATE TABLE selections (
  sid       INTEGER  PRIMARY KEY REFERENCES images ON DELETE CASCADE,
  photo_id  INTEGER  NOT NULL REFERENCES photos ON DELETE CASCADE,
  quality   TEXT     NOT NULL DEFAULT 'default' REFERENCES image_qualities,
  x         NUMERIC  NOT NULL DEFAULT 0,
  y         NUMERIC  NOT NULL DEFAULT 0,
  pct       BOOLEAN  NOT NULL DEFAULT FALSE
) WITHOUT ROWID;
CREATE TABLE image_scales (
  sid     INTEGER  PRIMARY KEY REFERENCES selections ON DELETE CASCADE,
  x       NUMERIC  NOT NULL DEFAULT 0,
  y       NUMERIC  NOT NULL DEFAULT 0,
  factor  NUMERIC  NOT NULL,
  fit     BOOLEAN  NOT NULL DEFAULT FALSE
) WITHOUT ROWID;
CREATE TABLE image_rotations (
  sid     INTEGER  PRIMARY KEY REFERENCES selections ON DELETE CASCADE,
  angle   NUMERIC  NOT NULL DEFAULT 0,
  mirror  BOOLEAN  NOT NULL DEFAULT FALSE
) WITHOUT ROWID;
CREATE TABLE image_qualities (
  quality  TEXT  NOT NULL PRIMARY KEY
) WITHOUT ROWID;
INSERT INTO "image_qualities" VALUES('bitonal');
INSERT INTO "image_qualities" VALUES('color');
INSERT INTO "image_qualities" VALUES('default');
INSERT INTO "image_qualities" VALUES('gray');
CREATE TABLE languages (
  language TEXT NOT NULL PRIMARY KEY,

  CHECK (language != ''),
  CHECK (language = trim(lower(language)))
) WITHOUT ROWID;
INSERT INTO "languages" VALUES('aa');
INSERT INTO "languages" VALUES('ab');
INSERT INTO "languages" VALUES('ae');
INSERT INTO "languages" VALUES('af');
INSERT INTO "languages" VALUES('am');
INSERT INTO "languages" VALUES('an');
INSERT INTO "languages" VALUES('ar');
INSERT INTO "languages" VALUES('as');
INSERT INTO "languages" VALUES('ay');
INSERT INTO "languages" VALUES('az');
INSERT INTO "languages" VALUES('ba');
INSERT INTO "languages" VALUES('be');
INSERT INTO "languages" VALUES('bg');
INSERT INTO "languages" VALUES('bh');
INSERT INTO "languages" VALUES('bi');
INSERT INTO "languages" VALUES('bn');
INSERT INTO "languages" VALUES('bo');
INSERT INTO "languages" VALUES('br');
INSERT INTO "languages" VALUES('bs');
INSERT INTO "languages" VALUES('ca');
INSERT INTO "languages" VALUES('ce');
INSERT INTO "languages" VALUES('ch');
INSERT INTO "languages" VALUES('co');
INSERT INTO "languages" VALUES('cs');
INSERT INTO "languages" VALUES('cu');
INSERT INTO "languages" VALUES('cv');
INSERT INTO "languages" VALUES('cy');
INSERT INTO "languages" VALUES('da');
INSERT INTO "languages" VALUES('de');
INSERT INTO "languages" VALUES('dv');
INSERT INTO "languages" VALUES('dz');
INSERT INTO "languages" VALUES('el');
INSERT INTO "languages" VALUES('en');
INSERT INTO "languages" VALUES('eo');
INSERT INTO "languages" VALUES('es');
INSERT INTO "languages" VALUES('et');
INSERT INTO "languages" VALUES('eu');
INSERT INTO "languages" VALUES('fa');
INSERT INTO "languages" VALUES('fi');
INSERT INTO "languages" VALUES('fj');
INSERT INTO "languages" VALUES('fo');
INSERT INTO "languages" VALUES('fr');
INSERT INTO "languages" VALUES('fy');
INSERT INTO "languages" VALUES('ga');
INSERT INTO "languages" VALUES('gd');
INSERT INTO "languages" VALUES('gl');
INSERT INTO "languages" VALUES('gn');
INSERT INTO "languages" VALUES('gu');
INSERT INTO "languages" VALUES('gv');
INSERT INTO "languages" VALUES('ha');
INSERT INTO "languages" VALUES('he');
INSERT INTO "languages" VALUES('hi');
INSERT INTO "languages" VALUES('ho');
INSERT INTO "languages" VALUES('hr');
INSERT INTO "languages" VALUES('ht');
INSERT INTO "languages" VALUES('hu');
INSERT INTO "languages" VALUES('hy');
INSERT INTO "languages" VALUES('hz');
INSERT INTO "languages" VALUES('ia');
INSERT INTO "languages" VALUES('id');
INSERT INTO "languages" VALUES('ie');
INSERT INTO "languages" VALUES('ii');
INSERT INTO "languages" VALUES('ik');
INSERT INTO "languages" VALUES('io');
INSERT INTO "languages" VALUES('is');
INSERT INTO "languages" VALUES('it');
INSERT INTO "languages" VALUES('iu');
INSERT INTO "languages" VALUES('ja');
INSERT INTO "languages" VALUES('jv');
INSERT INTO "languages" VALUES('ka');
INSERT INTO "languages" VALUES('ki');
INSERT INTO "languages" VALUES('kj');
INSERT INTO "languages" VALUES('kk');
INSERT INTO "languages" VALUES('kl');
INSERT INTO "languages" VALUES('km');
INSERT INTO "languages" VALUES('kn');
INSERT INTO "languages" VALUES('ko');
INSERT INTO "languages" VALUES('ks');
INSERT INTO "languages" VALUES('ku');
INSERT INTO "languages" VALUES('kv');
INSERT INTO "languages" VALUES('kw');
INSERT INTO "languages" VALUES('ky');
INSERT INTO "languages" VALUES('la');
INSERT INTO "languages" VALUES('lb');
INSERT INTO "languages" VALUES('li');
INSERT INTO "languages" VALUES('ln');
INSERT INTO "languages" VALUES('lo');
INSERT INTO "languages" VALUES('lt');
INSERT INTO "languages" VALUES('lv');
INSERT INTO "languages" VALUES('mg');
INSERT INTO "languages" VALUES('mh');
INSERT INTO "languages" VALUES('mi');
INSERT INTO "languages" VALUES('mk');
INSERT INTO "languages" VALUES('ml');
INSERT INTO "languages" VALUES('mn');
INSERT INTO "languages" VALUES('mo');
INSERT INTO "languages" VALUES('mr');
INSERT INTO "languages" VALUES('ms');
INSERT INTO "languages" VALUES('mt');
INSERT INTO "languages" VALUES('my');
INSERT INTO "languages" VALUES('na');
INSERT INTO "languages" VALUES('nb');
INSERT INTO "languages" VALUES('nd');
INSERT INTO "languages" VALUES('ne');
INSERT INTO "languages" VALUES('ng');
INSERT INTO "languages" VALUES('nl');
INSERT INTO "languages" VALUES('nn');
INSERT INTO "languages" VALUES('no');
INSERT INTO "languages" VALUES('nr');
INSERT INTO "languages" VALUES('nv');
INSERT INTO "languages" VALUES('ny');
INSERT INTO "languages" VALUES('oc');
INSERT INTO "languages" VALUES('om');
INSERT INTO "languages" VALUES('or');
INSERT INTO "languages" VALUES('os');
INSERT INTO "languages" VALUES('pa');
INSERT INTO "languages" VALUES('pi');
INSERT INTO "languages" VALUES('pl');
INSERT INTO "languages" VALUES('ps');
INSERT INTO "languages" VALUES('pt');
INSERT INTO "languages" VALUES('qu');
INSERT INTO "languages" VALUES('rm');
INSERT INTO "languages" VALUES('rn');
INSERT INTO "languages" VALUES('ro');
INSERT INTO "languages" VALUES('ru');
INSERT INTO "languages" VALUES('rw');
INSERT INTO "languages" VALUES('sa');
INSERT INTO "languages" VALUES('sc');
INSERT INTO "languages" VALUES('sd');
INSERT INTO "languages" VALUES('se');
INSERT INTO "languages" VALUES('sg');
INSERT INTO "languages" VALUES('si');
INSERT INTO "languages" VALUES('sk');
INSERT INTO "languages" VALUES('sl');
INSERT INTO "languages" VALUES('sm');
INSERT INTO "languages" VALUES('sn');
INSERT INTO "languages" VALUES('so');
INSERT INTO "languages" VALUES('sq');
INSERT INTO "languages" VALUES('sr');
INSERT INTO "languages" VALUES('ss');
INSERT INTO "languages" VALUES('st');
INSERT INTO "languages" VALUES('su');
INSERT INTO "languages" VALUES('sv');
INSERT INTO "languages" VALUES('sw');
INSERT INTO "languages" VALUES('ta');
INSERT INTO "languages" VALUES('te');
INSERT INTO "languages" VALUES('tg');
INSERT INTO "languages" VALUES('th');
INSERT INTO "languages" VALUES('ti');
INSERT INTO "languages" VALUES('tk');
INSERT INTO "languages" VALUES('tl');
INSERT INTO "languages" VALUES('tn');
INSERT INTO "languages" VALUES('to');
INSERT INTO "languages" VALUES('tr');
INSERT INTO "languages" VALUES('ts');
INSERT INTO "languages" VALUES('tt');
INSERT INTO "languages" VALUES('tw');
INSERT INTO "languages" VALUES('ty');
INSERT INTO "languages" VALUES('ug');
INSERT INTO "languages" VALUES('uk');
INSERT INTO "languages" VALUES('ur');
INSERT INTO "languages" VALUES('uz');
INSERT INTO "languages" VALUES('vi');
INSERT INTO "languages" VALUES('vo');
INSERT INTO "languages" VALUES('wa');
INSERT INTO "languages" VALUES('wo');
INSERT INTO "languages" VALUES('xh');
INSERT INTO "languages" VALUES('yi');
INSERT INTO "languages" VALUES('yo');
INSERT INTO "languages" VALUES('za');
INSERT INTO "languages" VALUES('zh');
INSERT INTO "languages" VALUES('zu');
CREATE TRIGGER insert_tags
  AFTER INSERT ON tags
  BEGIN
    UPDATE tags
      SET tag_name = trim(tag_name)
      WHERE tag_name = NEW.tag_name;
  END;
CREATE TRIGGER update_tags
  AFTER UPDATE ON tags
  BEGIN
    UPDATE tags
      SET tag_name = trim(tag_name)
      WHERE tag_name = NEW.tag_name;
  END;
CREATE TRIGGER insert_lists_set_position
  AFTER INSERT ON lists
  FOR EACH ROW WHEN NEW.position IS NULL
  BEGIN
    UPDATE lists
      SET position = 1 + coalesce(
        (
          SELECT max(position)
          FROM lists
          WHERE parent_list_id = NEW.parent_list_id
        ),
        0
      )
      WHERE list_id = NEW.list_id;
  END;
COMMIT;
PRAGMA foreign_keys=ON;