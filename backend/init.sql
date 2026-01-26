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

CREATE SCHEMA IF NOT EXISTS orng_employee;

CREATE TABLE IF NOT EXISTS orng_employee.positions
(
    id   BIGSERIAL PRIMARY KEY,
    code VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS orng_employee.employees
(
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT       NOT NULL UNIQUE,
    city_id     BIGINT       NOT NULL,
    code        VARCHAR(255) NOT NULL UNIQUE,
    full_name   VARCHAR(255) NOT NULL,
    email       VARCHAR(255),
    phone       VARCHAR(255),
    position_id BIGINT       NOT NULL REFERENCES orng_employee.positions (id),
    status      VARCHAR(255) NOT NULL DEFAULT 'ACTIVE',
    hired_at    DATE,
    fired_at    DATE,
    is_substitution_group BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
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

INSERT INTO orng_employee.positions (code, name)
VALUES ('CLIENT_MANAGER', 'Менеджер по работе с клиентами'),
       ('VIP_CLIENT_MANAGER', 'Менеджер по работе с ВИП клиентами'),
       ('LEGAL_ENTITY_MANAGER', 'Менеджер по работе с юридическими лицами'),
       ('OFFICE_HEAD', 'Руководитель офиса'),
       ('CASHIER', 'Кассир')
ON CONFLICT DO NOTHING;

INSERT INTO orng_employee.employees
(user_id, city_id, code, full_name, email, phone, position_id, status, hired_at, fired_at)
VALUES (1, 1, 'EMP-000001', 'Иванов Иван Иванович',
        'ivanov.ii@example.com', '+79990000001',
        (SELECT id FROM orng_employee.positions WHERE code = 'OFFICE_HEAD'),
        'ACTIVE', DATE '2023-10-10', NULL),
       (2, 1, 'EMP-000002', 'Петров Пётр Сергеевич',
        'petrov.ps@example.com', '+79990000002',
        (SELECT id FROM orng_employee.positions WHERE code = 'CLIENT_MANAGER'),
        'ACTIVE', DATE '2024-02-01', NULL),
       (3, 1, 'EMP-000003', 'Сидорова Анна Владимировна',
        'sidorova.av@example.com', '+79990000003',
        (SELECT id FROM orng_employee.positions WHERE code = 'VIP_CLIENT_MANAGER'),
        'ACTIVE', DATE '2024-03-12', NULL),
       (4, 1, 'EMP-000004', 'Кузнецов Дмитрий Олегович',
        'kuznetsov.do@example.com', '+79990000004',
        (SELECT id FROM orng_employee.positions WHERE code = 'LEGAL_ENTITY_MANAGER'),
        'ACTIVE', DATE '2024-04-05', NULL),
       (5, 1, 'EMP-000005', 'Морозова Елена Николаевна',
        'morozova.en@example.com', '+79990000005',
        (SELECT id FROM orng_employee.positions WHERE code = 'CASHIER'),
        'ACTIVE', DATE '2024-01-15', NULL),
       (6, 1, 'EMP-000006', 'Смирнов Артём Андреевич',
        'smirnov.aa@example.com', '+79990000006',
        (SELECT id FROM orng_employee.positions WHERE code = 'CASHIER'),
        'ACTIVE', DATE '2024-06-01', NULL),
       (7, 1, 'EMP-000007', 'Орлова Мария Игоревна',
        'orlova.mi@example.com', '+79990000007',
        (SELECT id FROM orng_employee.positions WHERE code = 'CLIENT_MANAGER'),
        'ACTIVE', DATE '2024-07-18', NULL),
       (8, 2, 'EMP-000008', 'Васильев Алексей Николаевич',
        'vasilev.an@example.com', '+79990000008',
        (SELECT id FROM orng_employee.positions WHERE code = 'OFFICE_HEAD'),
        'ACTIVE', DATE '2022-09-01', NULL),
       (9, 2, 'EMP-000009', 'Фёдорова Ольга Сергеевна',
        'fedorova.os@example.com', '+79990000009',
        (SELECT id FROM orng_employee.positions WHERE code = 'VIP_CLIENT_MANAGER'),
        'ACTIVE', DATE '2023-11-20', NULL),
       (10, 2, 'EMP-000010', 'Никитин Павел Дмитриевич',
        'nikitin.pd@example.com', '+79990000010',
        (SELECT id FROM orng_employee.positions WHERE code = 'LEGAL_ENTITY_MANAGER'),
        'ACTIVE', DATE '2024-02-10', NULL),
       (11, 2, 'EMP-000011', 'Захарова Ирина Викторовна',
        'zaharova.iv@example.com', '+79990000011',
        (SELECT id FROM orng_employee.positions WHERE code = 'CLIENT_MANAGER'),
        'ACTIVE', DATE '2024-03-25', NULL),
       (12, 2, 'EMP-000012', 'Громов Максим Евгеньевич',
        'gromov.me@example.com', '+79990000012',
        (SELECT id FROM orng_employee.positions WHERE code = 'CASHIER'),
        'ACTIVE', DATE '2024-01-09', NULL),
       (13, 2, 'EMP-000013', 'Белова Татьяна Андреевна',
        'belova.ta@example.com', '+79990000013',
        (SELECT id FROM orng_employee.positions WHERE code = 'CASHIER'),
        'FIRED', DATE '2023-12-05', DATE '2025-01-31'),
       (14, 2, 'EMP-000014', 'Комаров Илья Романович',
        'komarov.ir@example.com', '+79990000014',
        (SELECT id FROM orng_employee.positions WHERE code = 'CLIENT_MANAGER'),
        'ACTIVE', DATE '2024-08-02', NULL)
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
    city_id    INTEGER      NOT NULL,
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