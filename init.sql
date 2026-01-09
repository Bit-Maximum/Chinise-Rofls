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


create schema if not exists orng_schedule;

create table if not exists orng_schedule.shifts
(
    id          bigserial primary key,
    office_id   bigint      not null,
    employee_id bigint      not null,
    date        date        not null,
    time_from   time        not null,
    time_to     time        not null,
    shift_type  varchar(32) not null,
    is_deleted  boolean     not null default false,
    created_at  timestamptz not null default now(),
    updated_at  timestamptz not null default now(),
    constraint shifts_time_chk check (time_from < time_to)
);

INSERT INTO orng_schedule.shifts
(office_id, employee_id, date, time_from, time_to, shift_type, is_deleted, created_at, updated_at)
VALUES (1, 2, '2026-01-06', '09:00', '17:00', 'work', false, now(), now()),
       (1, 3, '2026-01-07', '09:00', '17:00', 'work', false, now(), now()),
       (1, 4, '2026-01-06', '10:00', '18:00', 'work', false, now(), now()),
       (1, 5, '2026-01-07', '10:00', '18:00', 'work', false, now(), now()),
       (1, 6, '2026-01-06', '08:00', '16:00', 'work', false, now(), now()),
       (1, 7, '2026-01-06', '09:00', '18:00', 'work', false, now(), now())
on conflict do nothing;


CREATE SCHEMA IF NOT EXISTS orng_employee;

create table if not exists orng_employee.positions
(
    id   bigserial primary key,
    code varchar(255)  not null unique,
    name varchar(255) not null
);

create table if not exists orng_employee.employees
(
    id          bigserial primary key,
    user_id     bigint       not null unique,
    office_id   bigint       not null,
    code        varchar(255)  not null unique,
    full_name   varchar(255) not null,
    email       varchar(255),
    phone       varchar(255),
    position_id bigint       not null references positions (id),
    status      varchar(255)  not null default 'ACTIVE',
    hired_at    date,
    fired_at    date,
    created_at  timestamptz  not null default now(),
    updated_at  timestamptz  not null default now()
);

insert into orng_employee.positions (code, name)
values ('CLIENT_MANAGER', 'Менеджер по работе с клиентами'),
       ('VIP_CLIENT_MANAGER', 'Менеджер по работе с ВИП клиентами'),
       ('LEGAL_ENTITY_MANAGER', 'Менеджер по работе с юридическими лицами'),
       ('OFFICE_HEAD', 'Руководитель офиса'),
       ('CASHIER', 'Кассир')
on conflict do nothing;

insert into orng_employee.employees
(user_id, office_id, code, full_name, email, phone, position_id, status, hired_at, fired_at)
values
    (1, 1, 'EMP-000001', 'Иванов Иван Иванович',
     'ivanov.ii@example.com', '+79990000001',
     (select id from positions where code = 'OFFICE_HEAD'),
     'ACTIVE', date '2023-10-10', null),
    (2, 1, 'EMP-000002', 'Петров Пётр Сергеевич',
     'petrov.ps@example.com', '+79990000002',
     (select id from positions where code = 'CLIENT_MANAGER'),
     'ACTIVE', date '2024-02-01', null),
    (3, 1, 'EMP-000003', 'Сидорова Анна Владимировна',
     'sidorova.av@example.com', '+79990000003',
     (select id from positions where code = 'VIP_CLIENT_MANAGER'),
     'ACTIVE', date '2024-03-12', null),
    (4, 1, 'EMP-000004', 'Кузнецов Дмитрий Олегович',
     'kuznetsov.do@example.com', '+79990000004',
     (select id from positions where code = 'LEGAL_ENTITY_MANAGER'),
     'ACTIVE', date '2024-04-05', null),
    (5, 1, 'EMP-000005', 'Морозова Елена Николаевна',
     'morozova.en@example.com', '+79990000005',
     (select id from positions where code = 'CASHIER'),
     'ACTIVE', date '2024-01-15', null),
    (6, 1, 'EMP-000006', 'Смирнов Артём Андреевич',
     'smirnov.aa@example.com', '+79990000006',
     (select id from positions where code = 'CASHIER'),
     'ACTIVE', date '2024-06-01', null),
    (7, 1, 'EMP-000007', 'Орлова Мария Игоревна',
     'orlova.mi@example.com', '+79990000007',
     (select id from positions where code = 'CLIENT_MANAGER'),
     'ACTIVE', date '2024-07-18', null),
    (8, 2, 'EMP-000008', 'Васильев Алексей Николаевич',
     'vasilev.an@example.com', '+79990000008',
     (select id from positions where code = 'OFFICE_HEAD'),
     'ACTIVE', date '2022-09-01', null),
    (9, 2, 'EMP-000009', 'Фёдорова Ольга Сергеевна',
     'fedorova.os@example.com', '+79990000009',
     (select id from positions where code = 'VIP_CLIENT_MANAGER'),
     'ACTIVE', date '2023-11-20', null),
    (10, 2, 'EMP-000010', 'Никитин Павел Дмитриевич',
     'nikitin.pd@example.com', '+79990000010',
     (select id from positions where code = 'LEGAL_ENTITY_MANAGER'),
     'ACTIVE', date '2024-02-10', null),
    (11, 2, 'EMP-000011', 'Захарова Ирина Викторовна',
     'zaharova.iv@example.com', '+79990000011',
     (select id from positions where code = 'CLIENT_MANAGER'),
     'ACTIVE', date '2024-03-25', null),
    (12, 2, 'EMP-000012', 'Громов Максим Евгеньевич',
     'gromov.me@example.com', '+79990000012',
     (select id from positions where code = 'CASHIER'),
     'ACTIVE', date '2024-01-09', null),
    (13, 2, 'EMP-000013', 'Белова Татьяна Андреевна',
     'belova.ta@example.com', '+79990000013',
     (select id from positions where code = 'CASHIER'),
     'FIRED', date '2023-12-05', date '2025-01-31'),
    (14, 2, 'EMP-000014', 'Комаров Илья Романович',
     'komarov.ir@example.com', '+79990000014',
     (select id from positions where code = 'CLIENT_MANAGER'),
     'ACTIVE', date '2024-08-02', null)
on conflict do nothing;
