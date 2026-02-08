CREATE SCHEMA IF NOT EXISTS orng_auth;


CREATE TABLE IF NOT EXISTS orng_auth.users
(
    id         BIGSERIAL PRIMARY KEY,
    username   VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ  NOT NULL DEFAULT NOW()

);

CREATE INDEX IF NOT EXISTS idx_username ON orng_auth.users (username);

CREATE TABLE IF NOT EXISTS orng_auth.roles
(
    id   BIGSERIAL PRIMARY KEY,
    code VARCHAR(128) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS orng_auth.user_role
(
    role_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    CONSTRAINT pk_user_role UNIQUE (user_id, role_id),

    CONSTRAINT fk_user_role_user
        FOREIGN KEY (user_id)
            REFERENCES orng_auth.users (id)
            ON DELETE CASCADE,

    CONSTRAINT fk_user_role_role
        FOREIGN KEY (role_id)
            REFERENCES orng_auth.roles (id)
            ON DELETE CASCADE

);


CREATE TABLE IF NOT EXISTS orng_auth.tokens
(
    id                 BIGSERIAL PRIMARY KEY,
    user_id            BIGINT                   NOT NULL,
    refresh_jti        UUID                     NOT NULL UNIQUE,
    access_jti         UUID                     NOT NULL UNIQUE,
    refresh_issued_at  TIMESTAMP WITH TIME ZONE NOT NULL,
    refresh_expired_at TIMESTAMP WITH TIME ZONE NOT NULL,

    CONSTRAINT fk_refresh_tokens_user_id
        FOREIGN KEY (user_id)
            REFERENCES orng_auth.users (id)
            ON DELETE CASCADE

);

CREATE INDEX IF NOT EXISTS idx_tokens_refresh_jti ON orng_auth.tokens (refresh_jti);


CREATE TABLE IF NOT EXISTS orng_auth.credentials
(
    id         BIGSERIAL PRIMARY KEY,
    user_id    BIGINT       NOT NULL,
    hash       VARCHAR(255) NOT NULL,
    salt       VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ  NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_credentials_user_id
        FOREIGN KEY (user_id)
            REFERENCES users (id)
            ON DELETE CASCADE

);

CREATE INDEX IF NOT EXISTS idx_credentials_user_id ON orng_auth.credentials (user_id);


INSERT INTO orng_auth.users (username)
VALUES ('admin1'),
       ('admin2'),
       ('user01'),
       ('user02'),
       ('user03'),
       ('user04'),
       ('user05'),
       ('user06'),
       ('user07'),
       ('user08'),
       ('user09'),
       ('user10'),
       ('user11'),
       ('user12'),
       ('user13'),
       ('user14'),
       ('user15'),
       ('user16'),
       ('user17'),
       ('user18'),
       ('user19'),
       ('user20'),
       ('user21'),
       ('user22'),
       ('user23'),
       ('user24'),
       ('user25'),
       ('user26'),
       ('user27'),
       ('user28'),
       ('user29'),
       ('user30'),
       ('user31'),
       ('user32'),
       ('user33'),
       ('user34'),
       ('user35'),
       ('user36'),
       ('user37'),
       ('user38')
ON CONFLICT (username) DO NOTHING;


INSERT INTO orng_auth.roles (code)
VALUES ('ROLE_ADMIN'),
       ('ROLE_MANAGER')
ON CONFLICT (code) DO NOTHING;


INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_ADMIN'
WHERE u.username IN ('admin1', 'admin2')
ON CONFLICT DO NOTHING;


INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_ADMIN'
WHERE u.username IN ('admin1', 'admin2')
ON CONFLICT DO NOTHING;


INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_MANAGER'
WHERE u.username LIKE 'user%'
ON CONFLICT DO NOTHING;


INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_MANAGER'
WHERE u.username LIKE 'user%'
ON CONFLICT DO NOTHING;


INSERT INTO orng_auth.credentials (user_id, hash, salt)
SELECT u.id,
       '$2a$10$abcdefghijklmnopqrstuvnOeGZ8e1kX8aPZCwF1QnYB9u6O4q9',
       'abcdefghijklmnopqrstuv'
FROM orng_auth.users u
ON CONFLICT DO NOTHING;


--  Сотрудники

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
    office_id   BIGINT       NOT NULL,
    code        VARCHAR(255) NOT NULL UNIQUE,
    full_name   VARCHAR(255) NOT NULL,
    email       VARCHAR(255),
    phone       VARCHAR(255),
    position_id BIGINT       NOT NULL REFERENCES positions (id),
    status      VARCHAR(255) NOT NULL DEFAULT 'ACTIVE',
    hired_at    DATE,
    fired_at    DATE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);
CREATE TABLE IF NOT EXISTS orng_employee.statuses
(
    id   BIGSERIAL PRIMARY KEY,
    code VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL
);
INSERT INTO orng_employee.statuses (code, name)
VALUES ('ACTIVE', 'Активный'),
       ('FIRED', 'Уволенный')
ON CONFLICT (code) DO NOTHING;
ALTER TABLE orng_employee.employees
    ADD COLUMN is_substitution_group BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE orng_employee.employees
    ALTER COLUMN office_id DROP NOT NULL;
ALTER TABLE orng_employee.employees
    ALTER COLUMN status DROP DEFAULT;
ALTER TABLE orng_employee.employees
    ALTER COLUMN status DROP NOT NULL;
ALTER TABLE orng_employee.employees
    ADD COLUMN city_id BIGINT NOT NULL;
ALTER TABLE orng_employee.employees
    ADD COLUMN status_id BIGINT NOT NULL;
ALTER TABLE orng_employee.employees
    ADD CONSTRAINT fk_employees_status FOREIGN KEY (status_id) REFERENCES statuses (id);
CREATE UNIQUE INDEX IF NOT EXISTS uq_employees_email ON orng_employee.employees (email) WHERE email IS NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS uq_employees_phone ON orng_employee.employees (phone) WHERE phone IS NOT NULL;
ALTER TABLE orng_employee.employees
    ADD CONSTRAINT chk_employees_hired_fired_dates CHECK ( hired_at IS NULL OR fired_at IS NULL OR fired_at >= hired_at );
INSERT INTO orng_employee.positions (code, name)
VALUES ('CLIENT_MANAGER', 'Менеджер по работе с клиентами'),
       ('VIP_CLIENT_MANAGER', 'Менеджер по работе с ВИП клиентами'),
       ('LEGAL_ENTITY_MANAGER', 'Менеджер по работе с юридическими лицами'),
       ('OFFICE_HEAD', 'Руководитель офиса'),
       ('CASHIER', 'Кассир')
ON CONFLICT (code) DO NOTHING;


INSERT INTO orng_employee.positions (id, code, name)
VALUES (1, 'CLIENT_MANAGER', 'Менеджер по работе с клиентами'),
       (2, 'VIP_CLIENT_MANAGER', 'Менеджер по работе с ВИП клиентами'),
       (3, 'LEGAL_ENTITY_MANAGER', 'Менеджер по работе с юридическими лицами'),
       (4, 'OFFICE_HEAD', 'Руководитель офиса'),
       (5, 'CASHIER', 'Кассир')
ON CONFLICT (code) DO NOTHING;


INSERT INTO orng_employee.statuses (id, code, name)
VALUES (1, 'ACTIVE', 'Активный'),
       (2, 'FIRED', 'Уволенный')
ON CONFLICT (code) DO NOTHING;


INSERT INTO orng_employee.employees
(id, user_id, office_id, code, full_name, email, phone,
 position_id, status_id, city_id, hired_at)
VALUES (1, 1, 1, 'EMP-0001', 'Иванов Иван Иванович',
        'admin1@company.ru', '+79000000001',
        4, 1, 1, '2022-01-10'),
       (2, 2, 2, 'EMP-0002', 'Петров Пётр Петрович',
        'admin2@company.ru', '+79000000002',
        4, 1, 2, '2022-01-10');


INSERT INTO orng_employee.employees
(user_id, code, full_name, email, phone,
 position_id, status_id, city_id, hired_at)
VALUES (3, 'EMP-0003', 'Смирнов Алексей Игоревич', 'user01@company.ru', '+79000000003', 1, 1, 1,
        '2023-02-01'),
       (4, 'EMP-0004', 'Кузнецов Дмитрий Сергеевич', 'user02@company.ru', '+79000000004', 2, 1, 2,
        '2023-02-01'),
       (5, 'EMP-0005', 'Попов Андрей Владимирович', 'user03@company.ru', '+79000000005', 3, 1, 1,
        '2023-02-01'),
       (6, 'EMP-0006', 'Соколов Михаил Олегович', 'user04@company.ru', '+79000000006', 5, 1, 2,
        '2023-02-01'),
       (7, 'EMP-0007', 'Лебедев Роман Евгеньевич', 'user05@company.ru', '+79000000007', 1, 1, 1,
        '2023-02-01'),
       (8, 'EMP-0008', 'Козлов Артём Андреевич', 'user06@company.ru', '+79000000008', 2, 1, 2,
        '2023-02-01'),
       (9, 'EMP-0009', 'Новиков Илья Павлович', 'user07@company.ru', '+79000000009', 3, 1, 1,
        '2023-02-01'),
       (10, 'EMP-0010', 'Морозов Кирилл Денисович', 'user08@company.ru', '+79000000010', 5, 1, 2,
        '2023-02-01'),
       (11, 'EMP-0011', 'Волков Максим Алексеевич', 'user09@company.ru', '+79000000011', 1, 1, 1,
        '2023-02-01'),
       (12, 'EMP-0012', 'Соловьёв Никита Романович', 'user10@company.ru', '+79000000012', 2, 1, 2,
        '2023-02-01'),
       (13, 'EMP-0013', 'Васильев Егор Михайлович', 'user11@company.ru', '+79000000013', 3, 1, 1,
        '2023-02-01'),
       (14, 'EMP-0014', 'Зайцев Денис Викторович', 'user12@company.ru', '+79000000014', 5, 1, 2,
        '2023-02-01'),
       (15, 'EMP-0015', 'Павлов Тимофей Сергеевич', 'user13@company.ru', '+79000000015', 1, 1, 1,
        '2023-02-01'),
       (16, 'EMP-0016', 'Семёнов Арсений Ильич', 'user14@company.ru', '+79000000016', 2, 1, 2,
        '2023-02-01'),
       (17, 'EMP-0017', 'Голубев Владислав Петрович', 'user15@company.ru', '+79000000017', 3, 1, 1,
        '2023-02-01'),
       (18, 'EMP-0018', 'Виноградов Степан Николаевич', 'user16@company.ru', '+79000000018', 5, 1,
        2, '2023-02-01'),
       (19, 'EMP-0019', 'Беляев Антон Юрьевич', 'user17@company.ru', '+79000000019', 1, 1, 1,
        '2023-02-01'),
       (20, 'EMP-0020', 'Фёдоров Матвей Константинович', 'user18@company.ru', '+79000000020', 2, 1,
        2, '2023-02-01'),
       (21, 'EMP-0021', 'Комаров Ярослав Витальевич', 'user19@company.ru', '+79000000021', 3, 1, 1,
        '2023-02-01'),
       (22, 'EMP-0022', 'Орлов Платон Алексеевич', 'user20@company.ru', '+79000000022', 5, 1, 2,
        '2023-02-01'),
       (23, 'EMP-0023', 'Макаров Данила Сергеевич', 'user21@company.ru', '+79000000023', 1, 1, 1,
        '2023-02-01'),
       (24, 'EMP-0024', 'Захаров Никита Валерьевич', 'user22@company.ru', '+79000000024', 2, 1, 2,
        '2023-02-01'),
       (25, 'EMP-0025', 'Калинин Артём Борисович', 'user23@company.ru', '+79000000025', 3, 1, 1,
        '2023-02-01'),
       (26, 'EMP-0026', 'Рябов Максим Львович', 'user24@company.ru', '+79000000026', 5, 1, 2,
        '2023-02-01'),
       (27, 'EMP-0027', 'Тихонов Вячеслав Игоревич', 'user25@company.ru', '+79000000027', 1, 1, 1,
        '2023-02-01'),
       (28, 'EMP-0028', 'Анисимов Роман Аркадьевич', 'user26@company.ru', '+79000000028', 2, 1, 2,
        '2023-02-01'),
       (29, 'EMP-0029', 'Королёв Алексей Тимофеевич', 'user27@company.ru', '+79000000029', 3, 1, 1,
        '2023-02-01'),
       (30, 'EMP-0030', 'Гусев Илья Станиславович', 'user28@company.ru', '+79000000030', 5, 1, 2,
        '2023-02-01'),
       (31, 'EMP-0031', 'Киселёв Павел Дмитриевич', 'user29@company.ru', '+79000000031', 1, 1, 1,
        '2023-02-01'),
       (32, 'EMP-0032', 'Борисов Артём Леонидович', 'user30@company.ru', '+79000000032', 2, 1, 2,
        '2023-02-01'),
       (33, 'EMP-0033', 'Жуков Владислав Олегович', 'user31@company.ru', '+79000000033', 3, 1, 1,
        '2023-02-01'),
       (34, 'EMP-0034', 'Дорофеев Никита Геннадьевич', 'user32@company.ru', '+79000000034', 5, 1, 2,
        '2023-02-01'),
       (35, 'EMP-0035', 'Ершов Константин Алексеевич', 'user33@company.ru', '+79000000035', 1, 1, 1,
        '2023-02-01'),
       (36, 'EMP-0036', 'Фролов Владислав Михайлович', 'user34@company.ru', '+79000000036', 2, 1, 2,
        '2023-02-01'),
       (37, 'EMP-0037', 'Никитин Данила Евгеньевич', 'user35@company.ru', '+79000000037', 3, 1, 1,
        '2023-02-01'),
       (38, 'EMP-0038', 'Александров Роман Степанович', 'user36@company.ru', '+79000000038', 5, 1,
        2, '2023-02-01'),
       (39, 'EMP-0039', 'Мельников Игорь Валентинович', 'user37@company.ru', '+79000000039', 1, 1,
        1, '2023-02-01'),
       (40, 'EMP-0040', 'Гаврилов Сергей Николаевич', 'user38@company.ru', '+79000000040', 2, 1, 2,
        '2023-02-01');


create schema if not exists orng_office;

CREATE TABLE IF NOT EXISTS orng_office.offices
(
    id         BIGSERIAL PRIMARY KEY,
    code       VARCHAR(255) NOT NULL UNIQUE,
    name       VARCHAR(255) NOT NULL,
    address    VARCHAR(255) NOT NULL UNIQUE,
    city_id    BIGINT       NOT NULL,
    head_id    BIGINT       NOT NULL,
    created_at TIMESTAMPTZ  NOT NULL,
    updated_at TIMESTAMPTZ  NOT NULL

);

CREATE INDEX IF NOT EXISTS IDX_OFFICES_ON_ADDRESS ON orng_office.offices (address);

CREATE TABLE IF NOT EXISTS orng_office.working_hours
(
    id          BIGSERIAL PRIMARY KEY,
    office_id   BIGINT                 NOT NULL,
    day_of_week SMALLINT               NOT NULL,
    starts_on   TIME WITHOUT TIME ZONE NOT NULL,
    ends_on     TIME WITHOUT TIME ZONE NOT NULL,

    CONSTRAINT FK_WORKING_HOURS_ON_OFFICE
        FOREIGN KEY (office_id)
            REFERENCES orng_office.offices (id)
            ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS orng_office.offices_employees
(
    office_id   BIGINT NOT NULL,
    employee_id BIGINT NOT NULL,

    CONSTRAINT pk_offices_employees PRIMARY KEY (office_id, employee_id),

    CONSTRAINT FK_OFFICES_EMPLOYEES_ON_OFFICE
        FOREIGN KEY (office_id)
            REFERENCES orng_office.offices (id)
            ON DELETE RESTRICT
);


INSERT INTO orng_office.offices
(id, code, name, address, city_id, head_id, created_at, updated_at)
VALUES
-- Москва
(1,
 'OFFICE-MSK',
 'Офис в Москве',
 'г. Москва, ул. Тверская, д. 1',
 1,
 1,
 NOW(),
 NOW()),
-- Санкт-Петербург
(2,
 'OFFICE-SPB',
 'Офис в Санкт-Петербурге',
 'г. Санкт-Петербург, Невский проспект, д. 10',
 2,
 2,
 NOW(),
 NOW());


INSERT INTO orng_office.working_hours
    (office_id, day_of_week, starts_on, ends_on)
VALUES (1, 1, '09:00', '18:00'),
       (1, 2, '09:00', '18:00'),
       (1, 3, '09:00', '18:00'),
       (1, 4, '09:00', '18:00'),
       (1, 5, '09:00', '18:00');

INSERT INTO orng_office.working_hours
    (office_id, day_of_week, starts_on, ends_on)
VALUES (2, 1, '09:00', '18:00'),
       (2, 2, '09:00', '18:00'),
       (2, 3, '09:00', '18:00'),
       (2, 4, '09:00', '18:00'),
       (2, 5, '09:00', '18:00'),
       (2, 6, '10:00', '16:00');


INSERT INTO orng_office.offices_employees (office_id, employee_id)
VALUES (1, 3),
       (1, 4),
       (1, 5),
       (1, 6),
       (1, 7),
       (1, 8),
       (1, 9),
       (1, 10),
       (1, 11),
       (1, 12),
       (1, 13),
       (1, 14),
       (1, 15),
       (1, 16),
       (1, 17),
       (1, 18),
       (1, 19),
       (1, 20),
       (1, 21);


INSERT INTO orng_office.offices_employees (office_id, employee_id)
VALUES (2, 22),
       (2, 23),
       (2, 24),
       (2, 25),
       (2, 26),
       (2, 27),
       (2, 28),
       (2, 29),
       (2, 30),
       (2, 31),
       (2, 32),
       (2, 33),
       (2, 34),
       (2, 35),
       (2, 36),
       (2, 37),
       (2, 38),
       (2, 39),
       (2, 40);
