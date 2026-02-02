CREATE SCHEMA IF NOT EXISTS orng_auth;

CREATE TABLE IF NOT EXISTS orng_auth.roles
(
    id   BIGSERIAL PRIMARY KEY,
    code VARCHAR(128) NOT NULL UNIQUE
);


INSERT INTO orng_auth.roles (code)
VALUES ('ROLE_DEFAULT'),
       ('ROLE_ADMIN'),
       ('ROLE_MANAGER')
ON CONFLICT (code) DO NOTHING;


CREATE SCHEMA IF NOT EXISTS orng_schedule;

create table if not exists orng_schedule.shifts
(
    id           bigserial primary key,
    office_id    bigint      not null,
    employee_id  bigint      not null,
    scheduled_on date        not null,
    start_at     time        not null,
    end_at       time        not null,
    is_deleted   boolean     not null default false,
    created_at   timestamptz not null default now(),
    updated_at   timestamptz not null default now(),
    constraint shifts_time_chk check (start_at < end_at)
);

create table if not exists orng_schedule.absence_types
(
    id   bigserial primary key,
    code varchar(255) not null unique,
    name varchar(255) not null
);

create table if not exists orng_schedule.absences
(
    id                bigserial primary key,
    employee_id       bigint      not null,
    absence_type_id bigint      not null references orng_schedule.absence_types (id),
    absent_on         date        not null,
    is_deleted        boolean     not null default false,
    created_at        timestamptz not null default now(),
    updated_at        timestamptz not null default now(),
    constraint ux_absences_employee_day unique (employee_id, absent_on)
);

insert into orng_schedule.absence_types(code, name)
values ('sick', 'Больничный'),
       ('vacation', 'Отпуск')
ON CONFLICT DO NOTHING;


-- employee 2: SICK 2026-01-08
INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on, is_deleted, created_at, updated_at)
SELECT 2, t.id, '2026-01-08'::date, false, now(), now()
FROM orng_schedule.absence_types t
WHERE t.code = 'sick'
ON CONFLICT (employee_id, absent_on) DO NOTHING;

-- employee 3: VOCATION 2026-01-09 .. 2026-01-11
INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on, is_deleted, created_at, updated_at)
SELECT 3, t.id, d::date, false, now(), now()
FROM orng_schedule.absence_types t,
     generate_series('2026-01-09'::date, '2026-01-11'::date, interval '1 day') d
WHERE t.code = 'vacation'
ON CONFLICT (employee_id, absent_on) DO NOTHING;

-- employee 4: SICK 2026-01-10
INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on, is_deleted, created_at, updated_at)
SELECT 4, t.id, '2026-01-10'::date, false, now(), now()
FROM orng_schedule.absence_types t
WHERE t.code = 'vacation'
ON CONFLICT (employee_id, absent_on) DO NOTHING;

-- employee 5: VOCATION 2026-01-12 .. 2026-01-14
INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on, is_deleted, created_at, updated_at)
SELECT 5, t.id, d::date, false, now(), now()
FROM orng_schedule.absence_types t,
     generate_series('2026-01-12'::date, '2026-01-14'::date, interval '1 day') d
WHERE t.code = 'vacation'
ON CONFLICT (employee_id, absent_on) DO NOTHING;

-- employee 6: SICK 2026-01-09
INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on, is_deleted, created_at, updated_at)
SELECT 6, t.id, '2026-01-09'::date, false, now(), now()
FROM orng_schedule.absence_types t
WHERE t.code = 'sick'
ON CONFLICT (employee_id, absent_on) DO NOTHING;

-- employee 7: VOCATION 2026-01-08 .. 2026-01-09
INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on, is_deleted, created_at, updated_at)
SELECT 7, t.id, d::date, false, now(), now()
FROM orng_schedule.absence_types t,
     generate_series('2026-01-08'::date, '2026-01-09'::date, interval '1 day') d
WHERE t.code = 'vacation'
ON CONFLICT (employee_id, absent_on) DO NOTHING;


INSERT INTO orng_schedule.shifts
(office_id, employee_id, scheduled_on, start_at, end_at, is_deleted, created_at, updated_at)
VALUES (1, 2, '2026-01-06', '09:00', '17:00', false, now(), now()),
       (1, 3, '2026-01-07', '09:00', '17:00', false, now(), now()),
       (1, 4, '2026-01-06', '10:00', '18:00', false, now(), now()),
       (1, 5, '2026-01-07', '10:00', '18:00', false, now(), now()),
       (1, 6, '2026-01-06', '08:00', '16:00', false, now(), now()),
       (1, 7, '2026-01-06', '09:00', '18:00', false, now(), now());


CREATE SCHEMA IF NOT EXISTS orng_office;

CREATE TABLE IF NOT EXISTS orng_office.offices
(
    id         BIGSERIAL PRIMARY KEY,
    code       VARCHAR(255) NOT NULL,
    name       VARCHAR(255) NOT NULL,
    address    VARCHAR(255) NOT NULL UNIQUE,
    city_id    BIGINT      NOT NULL,
    created_at TIMESTAMPTZ  NOT NULL,
    updated_at TIMESTAMPTZ  NOT NULL
);

CREATE TABLE IF NOT EXISTS orng_office.offices_employees
(
    office_id   BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,
    CONSTRAINT pk_offices_employees PRIMARY KEY (office_id, employee_id),
    CONSTRAINT FK_OFFICES_EMPLOYEES_ON_OFFICE_ENTITY FOREIGN KEY (office_id) REFERENCES orng_office.offices (id)
);

CREATE TABLE IF NOT EXISTS orng_office.working_hours
(
    id          BIGSERIAL              NOT NULL,
    office_id   BIGINT                 NOT NULL,
    day_of_week SMALLINT               NOT NULL,
    starts_on   TIME WITHOUT TIME ZONE NOT NULL,
    ends_on     TIME WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT pk_working_hours PRIMARY KEY (id),
    CONSTRAINT unique_office_id_day_of_week UNIQUE (office_id, day_of_week),
    CONSTRAINT FK_WORKING_HOURS_ON_OFFICE FOREIGN KEY (office_id) REFERENCES orng_office.offices (id)
);

-- Вставка данных в таблицу offices
INSERT INTO orng_office.offices (code, name, address, city_id, created_at, updated_at)
VALUES ('MOS001', 'Главный офис Москва', 'ул. Тверская, д. 10', 1, '2023-01-15 10:00:00',
        '2024-01-15 09:30:00'),
       ('LED001', 'Офис в Санкт-Петербурге', 'Невский пр., д. 25', 4, '2023-02-20 14:00:00',
        '2024-01-10 11:20:00'),
       ('EKB001', 'Екатеринбург Центральный', 'ул. Ленина, д. 50', 6, '2023-03-10 09:00:00',
        '2024-01-12 16:45:00'),
       ('NVS001', 'Новосибирск Западный', 'ул. Кирова, д. 33', 8, '2023-04-05 11:30:00',
        '2024-01-08 14:15:00'),
       ('KRR001', 'Краснодар Южный', 'ул. Красная, д. 15', 9, '2023-05-12 13:00:00',
        '2024-01-05 10:00:00'),
       ('KZN001', 'Казань Центр', 'ул. Баумана, д. 12', 11, '2023-06-08 10:30:00',
        '2024-01-03 09:45:00'),
       ('HIM001', 'Химки Бизнес-парк', 'ул. Ленинградская, д. 5', 2, '2023-07-01 15:00:00',
        '2023-12-20 17:30:00'),
       ('SOC001', 'Сочи Олимпийский', 'ул. Орджоникидзе, д. 8', 10, '2023-08-14 16:00:00',
        '2024-01-02 13:20:00');

-- Вставка данных в таблицу offices_employees (связь офисов с сотрудниками)
INSERT INTO orng_office.offices_employees (office_id, employee_id)
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (2, 1),
       (2, 2),
       (3, 4),
       (3, 3),
       (3, 5),
       (3, 6),
       (4, 7),
       (4, 8),
       (5, 9),
       (5, 10),
       (5, 3),
       (6, 2),
       (6, 1),
       (8, 4),
       (8, 5);

-- Вставка данных в таблицу working_hours (рабочие часы для каждого офиса)
INSERT INTO orng_office.working_hours (office_id, day_of_week, starts_on, ends_on)
VALUES
    -- Офис MOS001 (Пн-Пт)
    (1, 1, '09:00', '18:00'),
    (1, 2, '09:00', '18:00'),
    (1, 3, '09:00', '18:00'),
    (1, 4, '09:00', '18:00'),
    (1, 5, '09:00', '17:00'),
    -- Офис LED001 (Пн-Пт, сб короткий день)
    (2, 1, '10:00', '19:00'),
    (2, 2, '10:00', '19:00'),
    (2, 3, '10:00', '19:00'),
    (2, 4, '10:00', '19:00'),
    (2, 5, '10:00', '18:00'),
    (2, 6, '11:00', '15:00'),
    -- Офис EKB001
    (3, 1, '08:30', '17:30'),
    (3, 2, '08:30', '17:30'),
    (3, 3, '08:30', '17:30'),
    (3, 4, '08:30', '17:30'),
    (3, 5, '08:30', '16:30'),
    -- Офис NVS001
    (4, 1, '09:00', '18:00'),
    (4, 2, '09:00', '18:00'),
    (4, 3, '09:00', '18:00'),
    (4, 4, '09:00', '18:00'),
    (4, 5, '09:00', '17:00'),
    -- Офис KRR001
    (5, 1, '08:00', '17:00'),
    (5, 2, '08:00', '17:00'),
    (5, 3, '08:00', '17:00'),
    (5, 4, '08:00', '17:00'),
    (5, 5, '08:00', '16:00'),
    -- Офис KZN001
    (6, 1, '09:30', '18:30'),
    (6, 2, '09:30', '18:30'),
    (6, 3, '09:30', '18:30'),
    (6, 4, '09:30', '18:30'),
    (6, 5, '09:30', '17:30'),
    -- Офис SOC001
    (8, 1, '10:00', '19:00'),
    (8, 2, '10:00', '19:00'),
    (8, 3, '10:00', '19:00'),
    (8, 4, '10:00', '19:00'),
    (8, 5, '10:00', '18:00'),
    (8, 6, '11:00', '16:00');