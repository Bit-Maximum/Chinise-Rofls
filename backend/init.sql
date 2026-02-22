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
       ('user38'),
       ('user39'),
       ('user40'),
       ('user41'),
       ('user42'),
       ('user43'),
       ('user44'),
       ('user45'),
       ('user46'),
       ('user47'),
       ('user48'),
       ('system'),
       ('region1')
ON CONFLICT (username) DO NOTHING;

INSERT INTO orng_auth.roles (code)
VALUES ('ROLE_ADMIN'),
       ('ROLE_MANAGER'),
       ('ROLE_OFFICE_HEAD'),
       ('ROLE_REGION_MANAGER')
ON CONFLICT (code) DO NOTHING;

INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_OFFICE_HEAD'
WHERE u.username IN ('admin1', 'admin2', 'system')
ON CONFLICT DO NOTHING;

INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_MANAGER'
WHERE u.username IN ('system')
ON CONFLICT DO NOTHING;

INSERT INTO orng_auth.user_role (user_id, role_id)
SELECT u.id, r.id
FROM orng_auth.users u
         JOIN orng_auth.roles r ON r.code = 'ROLE_ADMIN'
WHERE u.username IN ('admin1', 'admin2', 'system')
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
         JOIN orng_auth.roles r ON r.code = 'ROLE_REGION_MANAGER'
WHERE u.username IN ('region1')
ON CONFLICT DO NOTHING;

INSERT INTO orng_auth.credentials (user_id, hash, salt)
SELECT u.id,
       '$2a$10$bLizDEiVzJ3UdZz38/cpkummoMBwOsenB.oM6pOeatk4FjFCne07.',
       '$2a$10$bLizDEiVzJ3UdZz38/cpku'
FROM orng_auth.users u
ON CONFLICT DO NOTHING;

INSERT INTO orng_employee.statuses (code, name)
VALUES ('ACTIVE', 'Активный'),
       ('FIRED', 'Уволенный')
ON CONFLICT (code) DO NOTHING;

INSERT INTO orng_employee.positions (code, name)
VALUES ('CLIENT_MANAGER', 'Менеджер по работе с клиентами'),
       ('VIP_CLIENT_MANAGER', 'Менеджер по работе с ВИП клиентами'),
       ('LEGAL_ENTITY_MANAGER', 'Менеджер по работе с юридическими лицами'),
       ('OFFICE_HEAD', 'Руководитель офиса'),
       ('CASHIER', 'Кассир'),
       ('REGION_MANAGER', 'Территориальный менеджер')
ON CONFLICT (code) DO NOTHING;

INSERT INTO orng_employee.employees
(user_id, code, full_name, email, phone,
 position_id, status_id, city_id, region_id, hired_at)
VALUES (1, 'EMP-0001', 'Иванов Иван Иванович',
        'admin1@company.ru', '+79000000001',
        4, 1, 1, 1, '2022-01-10'),
       (2, 'EMP-0002', 'Петров Пётр Петрович',
        'admin2@company.ru', '+79000000002',
        4, 1, 1, 1, '2022-01-10')
ON CONFLICT DO NOTHING;

INSERT INTO orng_employee.employees
(user_id, code, full_name, email, phone,
 position_id, status_id, city_id, region_id, hired_at)
VALUES (3, 'EMP-0003', 'Смирнов Алексей Игоревич', 'user01@company.ru', '+79000000003', 1, 1, 1, 1,
        '2023-02-01'),
       (4, 'EMP-0004', 'Кузнецов Дмитрий Сергеевич', 'user02@company.ru', '+79000000004', 2, 1, 1, 1,
        '2023-02-01'),
       (5, 'EMP-0005', 'Попов Андрей Владимирович', 'user03@company.ru', '+79000000005', 3, 1, 1, 1,
        '2023-02-01'),
       (6, 'EMP-0006', 'Соколов Михаил Олегович', 'user04@company.ru', '+79000000006', 5, 1, 1, 1,
        '2023-02-01'),
       (7, 'EMP-0007', 'Лебедев Роман Евгеньевич', 'user05@company.ru', '+79000000007', 1, 1, 1, 1,
        '2023-02-01'),
       (8, 'EMP-0008', 'Козлов Артём Андреевич', 'user06@company.ru', '+79000000008', 2, 1, 1, 1,
        '2023-02-01'),
       (9, 'EMP-0009', 'Новиков Илья Павлович', 'user07@company.ru', '+79000000009', 3, 1, 1, 1,
        '2023-02-01'),
       (10, 'EMP-0010', 'Морозов Кирилл Денисович', 'user08@company.ru', '+79000000010', 5, 1, 1, 1,
        '2023-02-01'),
       (11, 'EMP-0011', 'Волков Максим Алексеевич', 'user09@company.ru', '+79000000011', 1, 1, 1, 1,
        '2023-02-01'),
       (12, 'EMP-0012', 'Соловьёв Никита Романович', 'user10@company.ru', '+79000000012', 2, 1, 1, 1,
        '2023-02-01'),
       (13, 'EMP-0013', 'Васильев Егор Михайлович', 'user11@company.ru', '+79000000013', 3, 1, 1, 1,
        '2023-02-01'),
       (14, 'EMP-0014', 'Зайцев Денис Викторович', 'user12@company.ru', '+79000000014', 5, 1, 1, 1,
        '2023-02-01'),
       (15, 'EMP-0015', 'Павлов Тимофей Сергеевич', 'user13@company.ru', '+79000000015', 1, 1, 1, 1,
        '2023-02-01'),
       (16, 'EMP-0016', 'Семёнов Арсений Ильич', 'user14@company.ru', '+79000000016', 2, 1, 1, 1,
        '2023-02-01'),
       (17, 'EMP-0017', 'Голубев Владислав Петрович', 'user15@company.ru', '+79000000017', 3, 1, 1, 1,
        '2023-02-01'),
       (18, 'EMP-0018', 'Виноградов Степан Николаевич', 'user16@company.ru', '+79000000018', 5, 1, 1,
        1, '2023-02-01'),
       (19, 'EMP-0019', 'Беляев Антон Юрьевич', 'user17@company.ru', '+79000000019', 1, 1, 1, 1,
        '2023-02-01'),
       (20, 'EMP-0020', 'Фёдоров Матвей Константинович', 'user18@company.ru', '+79000000020', 2, 1, 1,
        1, '2023-02-01'),
       (21, 'EMP-0021', 'Комаров Ярослав Витальевич', 'user19@company.ru', '+79000000021', 3, 1, 1, 1,
        '2023-02-01'),
       (22, 'EMP-0022', 'Орлов Платон Алексеевич', 'user20@company.ru', '+79000000022', 5, 1, 1, 1,
        '2023-02-01'),
       (23, 'EMP-0023', 'Макаров Данила Сергеевич', 'user21@company.ru', '+79000000023', 1, 1, 1, 1,
        '2023-02-01'),
       (24, 'EMP-0024', 'Захаров Никита Валерьевич', 'user22@company.ru', '+79000000024', 2, 1, 1, 1,
        '2023-02-01'),
       (25, 'EMP-0025', 'Калинин Артём Борисович', 'user23@company.ru', '+79000000025', 3, 1, 1, 1,
        '2023-02-01'),
       (26, 'EMP-0026', 'Рябов Максим Львович', 'user24@company.ru', '+79000000026', 5, 1, 1, 1,
        '2023-02-01'),
       (27, 'EMP-0027', 'Тихонов Вячеслав Игоревич', 'user25@company.ru', '+79000000027', 1, 1, 1, 1,
        '2023-02-01'),
       (28, 'EMP-0028', 'Анисимов Роман Аркадьевич', 'user26@company.ru', '+79000000028', 2, 1, 1, 1,
        '2023-02-01'),
       (29, 'EMP-0029', 'Королёв Алексей Тимофеевич', 'user27@company.ru', '+79000000029', 3, 1, 1, 1,
        '2023-02-01'),
       (30, 'EMP-0030', 'Гусев Илья Станиславович', 'user28@company.ru', '+79000000030', 5, 1, 1, 1,
        '2023-02-01'),
       (31, 'EMP-0031', 'Киселёв Павел Дмитриевич', 'user29@company.ru', '+79000000031', 1, 1, 1, 1,
        '2023-02-01'),
       (32, 'EMP-0032', 'Борисов Артём Леонидович', 'user30@company.ru', '+79000000032', 2, 1, 1, 1,
        '2023-02-01'),
       (33, 'EMP-0033', 'Жуков Владислав Олегович', 'user31@company.ru', '+79000000033', 3, 1, 1, 1,
        '2023-02-01'),
       (34, 'EMP-0034', 'Дорофеев Никита Геннадьевич', 'user32@company.ru', '+79000000034', 5, 1, 1, 1,
        '2023-02-01'),
       (35, 'EMP-0035', 'Ершов Константин Алексеевич', 'user33@company.ru', '+79000000035', 1, 1, 1, 1,
        '2023-02-01'),
       (36, 'EMP-0036', 'Фролов Владислав Михайлович', 'user34@company.ru', '+79000000036', 2, 1, 1, 1,
        '2023-02-01'),
       (37, 'EMP-0037', 'Никитин Данила Евгеньевич', 'user35@company.ru', '+79000000037', 3, 1, 1, 1,
        '2023-02-01'),
       (38, 'EMP-0038', 'Александров Роман Степанович', 'user36@company.ru', '+79000000038', 5, 1, 1,
        1, '2023-02-01'),
       (39, 'EMP-0039', 'Мельников Игорь Валентинович', 'user37@company.ru', '+79000000039', 1, 1, 1,
        1, '2023-02-01'),
       (40, 'EMP-0040', 'Гаврилов Сергей Николаевич', 'user38@company.ru', '+79000000040', 2, 1, 1, 1,
        '2023-02-01')
ON CONFLICT DO NOTHING;

INSERT INTO orng_employee.employees
(user_id, code, full_name, email, phone,
 position_id, status_id, city_id, region_id, hired_at, is_substitution_group)
VALUES
(41, 'EMP-0041', 'Абрамов Георгий Николаевич', 'user39@company.ru', '+79000000041', 1, 1, 1, 1, '2023-02-01', true),
(42, 'EMP-0042', 'Тарасов Матвей Ильич', 'user40@company.ru', '+79000000042', 2, 1, 1, 1, '2023-02-01', true),
(43, 'EMP-0043', 'Крылов Арсений Павлович', 'user41@company.ru', '+79000000043', 3, 1, 1, 1, '2023-02-01', true),
(44, 'EMP-0044', 'Быков Даниил Сергеевич', 'user42@company.ru', '+79000000044', 5, 1, 1, 1, '2023-02-01', true),
(45, 'EMP-0045', 'Родионов Егор Максимович', 'user43@company.ru', '+79000000045', 1, 1, 1, 1, '2023-02-01', true),
(46, 'EMP-0046', 'Громов Тимофей Андреевич', 'user44@company.ru', '+79000000046', 2, 1, 1, 1, '2023-02-01', true),
(47, 'EMP-0047', 'Субботин Илья Романович', 'user45@company.ru', '+79000000047', 3, 1, 1, 1, '2023-02-01', true),
(48, 'EMP-0048', 'Баранов Владислав Олегович', 'user46@company.ru', '+79000000048', 5, 1, 1, 1, '2023-02-01', true),
(49, 'EMP-0049', 'Минин Константин Викторович', 'user47@company.ru', '+79000000049', 1, 1, 1, 1, '2023-02-01', true),
(50, 'EMP-0050', 'Сурков Артём Валерьевич', 'user48@company.ru', '+79000000050', 2, 1, 1, 1, '2023-02-01', true)
ON CONFLICT DO NOTHING;

INSERT INTO orng_employee.employees
(user_id, code, full_name, email, phone,
 position_id, status_id, city_id, region_id, hired_at)
VALUES (52, 'REG-0001', 'Иванов Иван Иванович', 'region1@company.ru', '+79000000083', 11, 1, 1, 1,
        '2023-02-01')
ON CONFLICT DO NOTHING;

INSERT INTO orng_office.offices
(id, code, name, address, city_id, region_id, head_id, created_at, updated_at)
VALUES
(1,
 'OFFICE-MS4K1',
 'Офис на Вознесенском переулке',
 'г. Москва, Вознесенский переулок, 11 ст1',
 1,
  1,
 1,
 NOW(),
 NOW()),
(2,
 'OFFICE-MSK3',
 'Офис на Александра Солженицын',
 'г. Москва, ул. Александра Солженицына, 8 ст1',
 1,
 1,
 1,
 NOW(),
 NOW())
ON CONFLICT DO NOTHING;

INSERT INTO orng_office.working_hours
    (office_id, day_of_week, starts_on, ends_on)
VALUES (1, 0, '09:00', '18:00'),
       (1, 1, '09:00', '18:00'),
       (1, 2, '09:00', '18:00'),
       (1, 3, '09:00', '18:00'),
       (1, 4, '09:00', '18:00')
ON CONFLICT DO NOTHING;

INSERT INTO orng_office.working_hours
    (office_id, day_of_week, starts_on, ends_on)
VALUES (2, 0, '09:00', '18:00'),
       (2, 1, '09:00', '18:00'),
       (2, 2, '09:00', '18:00'),
       (2, 3, '09:00', '18:00'),
       (2, 4, '09:00', '18:00'),
       (2, 5, '10:00', '16:00')
ON CONFLICT DO NOTHING;

INSERT INTO orng_office.offices_employees (office_id, employee_id)
VALUES (1, 3),
       (1, 5),
       (1, 7),
       (1, 9),
       (1, 11),
       (1, 13),
       (1, 15),
       (1, 17),
       (1, 19),
       (1, 21),
       (1, 23),
       (1, 25),
       (1, 27),
       (1, 29),
       (1, 31),
       (1, 33),
       (1, 35),
       (1, 37),
       (1, 39)
ON CONFLICT DO NOTHING;

INSERT INTO orng_office.offices_employees (office_id, employee_id)
VALUES (2, 4),
       (2, 6),
       (2, 8),
       (2, 10),
       (2, 12),
       (2, 14),
       (2, 16),
       (2, 18),
       (2, 20),
       (2, 22),
       (2, 24),
       (2, 26),
       (2, 28),
       (2, 30),
       (2, 32),
       (2, 34),
       (2, 36),
       (2, 38),
       (2, 40)
ON CONFLICT DO NOTHING;

INSERT INTO orng_office.offices_employees (office_id, employee_id)
VALUES (2, 3),
       (2, 5),
       (2, 9),
       (2, 11),
       (2, 23),
		(1, 4),
       (1, 8),
       (1, 6),
       (1, 10),
       (1, 14)
ON CONFLICT DO NOTHING;

INSERT INTO orng_catalog.regions (code, name, created_at, updated_at)
VALUES ('01', 'Республика Адыгея', NOW(), NOW()),
       ('02', 'Республика Башкортостан', NOW(), NOW()),
       ('03', 'Республика Бурятия', NOW(), NOW()),
       ('04', 'Республика Алтай', NOW(), NOW()),
       ('05', 'Республика Дагестан', NOW(), NOW()),
       ('06', 'Республика Ингушетия', NOW(), NOW()),
       ('07', 'Кабардино-Балкарская Республика', NOW(), NOW()),
       ('08', 'Республика Калмыкия', NOW(), NOW()),
       ('09', 'Карачаево-Черкесская Республика', NOW(), NOW()),
       ('10', 'Республика Карелия', NOW(), NOW()),
       ('11', 'Республика Коми', NOW(), NOW()),
       ('12', 'Республика Марий Эл', NOW(), NOW()),
       ('13', 'Республика Мордовия', NOW(), NOW()),
       ('14', 'Республика Саха (Якутия)', NOW(), NOW()),
       ('15', 'Республика Северная Осетия - Алания', NOW(), NOW()),
       ('16', 'Республика Татарстан', NOW(), NOW()),
       ('17', 'Республика Тыва', NOW(), NOW()),
       ('18', 'Удмуртская Республика', NOW(), NOW()),
       ('19', 'Республика Хакасия', NOW(), NOW()),
       ('20', 'Чеченская Республика', NOW(), NOW()),
       ('21', 'Чувашская Республика', NOW(), NOW()),
       ('22', 'Алтайский край', NOW(), NOW()),
       ('23', 'Краснодарский край', NOW(), NOW()),
       ('24', 'Красноярский край', NOW(), NOW()),
       ('25', 'Приморский край', NOW(), NOW()),
       ('26', 'Ставропольский край', NOW(), NOW()),
       ('27', 'Хабаровский край', NOW(), NOW()),
       ('28', 'Амурская область', NOW(), NOW()),
       ('29', 'Архангельская область', NOW(), NOW()),
       ('30', 'Астраханская область', NOW(), NOW()),
       ('31', 'Белгородская область', NOW(), NOW()),
       ('32', 'Брянская область', NOW(), NOW()),
       ('33', 'Владимирская область', NOW(), NOW()),
       ('34', 'Волгоградская область', NOW(), NOW()),
       ('35', 'Вологодская область', NOW(), NOW()),
       ('36', 'Воронежская область', NOW(), NOW()),
       ('37', 'Ивановская область', NOW(), NOW()),
       ('38', 'Иркутская область', NOW(), NOW()),
       ('39', 'Калининградская область', NOW(), NOW()),
       ('40', 'Калужская область', NOW(), NOW()),
       ('41', 'Камчатский край', NOW(), NOW()),
       ('42', 'Кемеровская область', NOW(), NOW()),
       ('43', 'Кировская область', NOW(), NOW()),
       ('44', 'Костромская область', NOW(), NOW()),
       ('45', 'Курганская область', NOW(), NOW()),
       ('46', 'Курская область', NOW(), NOW()),
       ('47', 'Ленинградская область', NOW(), NOW()),
       ('48', 'Липецкая область', NOW(), NOW()),
       ('49', 'Магаданская область', NOW(), NOW()),
       ('50', 'Московская область', NOW(), NOW()),
       ('51', 'Мурманская область', NOW(), NOW()),
       ('52', 'Нижегородская область', NOW(), NOW()),
       ('53', 'Новгородская область', NOW(), NOW()),
       ('54', 'Новосибирская область', NOW(), NOW()),
       ('55', 'Омская область', NOW(), NOW()),
       ('56', 'Оренбургская область', NOW(), NOW()),
       ('57', 'Орловская область', NOW(), NOW()),
       ('58', 'Пензенская область', NOW(), NOW()),
       ('59', 'Пермский край', NOW(), NOW()),
       ('60', 'Псковская область', NOW(), NOW()),
       ('61', 'Ростовская область', NOW(), NOW()),
       ('62', 'Рязанская область', NOW(), NOW()),
       ('63', 'Самарская область', NOW(), NOW()),
       ('64', 'Саратовская область', NOW(), NOW()),
       ('65', 'Сахалинская область', NOW(), NOW()),
       ('66', 'Свердловская область', NOW(), NOW()),
       ('67', 'Смоленская область', NOW(), NOW()),
       ('68', 'Тамбовская область', NOW(), NOW()),
       ('69', 'Тверская область', NOW(), NOW()),
       ('70', 'Томская область', NOW(), NOW()),
       ('71', 'Тульская область', NOW(), NOW()),
       ('72', 'Тюменская область', NOW(), NOW()),
       ('73', 'Ульяновская область', NOW(), NOW()),
       ('74', 'Челябинская область', NOW(), NOW()),
       ('75', 'Забайкальский край', NOW(), NOW()),
       ('76', 'Ярославская область', NOW(), NOW()),
       ('77', 'Москва', NOW(), NOW()),
       ('78', 'Санкт-Петербург', NOW(), NOW()),
       ('79', 'Еврейская автономная область', NOW(), NOW()),
       ('83', 'Ненецкий автономный округ', NOW(), NOW()),
       ('86', 'Ханты-Мансийский автономный округ - Югра', NOW(), NOW()),
       ('87', 'Чукотский автономный округ', NOW(), NOW()),
       ('89', 'Ямало-Ненецкий автономный округ', NOW(), NOW()),
       ('91', 'Республика Крым', NOW(), NOW()),
       ('92', 'Севастополь', NOW(), NOW()),
       ('99', 'Иные территории, включая город и космодром Байконур', NOW(), NOW())
ON CONFLICT (code) DO NOTHING;

INSERT INTO orng_catalog.cities (name, region_id, created_at, updated_at)
VALUES
    ('Москва', (SELECT id FROM orng_catalog.regions WHERE code = '77'), NOW(), NOW()),
    ('Санкт-Петербург', (SELECT id FROM orng_catalog.regions WHERE code = '78'), NOW(), NOW()),
    ('Балашиха', (SELECT id FROM orng_catalog.regions WHERE code = '50'), NOW(), NOW()),
    ('Химки', (SELECT id FROM orng_catalog.regions WHERE code = '50'), NOW(), NOW()),
    ('Подольск', (SELECT id FROM orng_catalog.regions WHERE code = '50'), NOW(), NOW()),
    ('Королёв', (SELECT id FROM orng_catalog.regions WHERE code = '50'), NOW(), NOW()),
    ('Мытищи', (SELECT id FROM orng_catalog.regions WHERE code = '50'), NOW(), NOW()),
    ('Гатчина', (SELECT id FROM orng_catalog.regions WHERE code = '47'), NOW(), NOW()),
    ('Выборг', (SELECT id FROM orng_catalog.regions WHERE code = '47'), NOW(), NOW()),
    ('Тосно', (SELECT id FROM orng_catalog.regions WHERE code = '47'), NOW(), NOW()),
    ('Краснодар', (SELECT id FROM orng_catalog.regions WHERE code = '23'), NOW(), NOW()),
    ('Сочи', (SELECT id FROM orng_catalog.regions WHERE code = '23'), NOW(), NOW()),
    ('Новороссийск', (SELECT id FROM orng_catalog.regions WHERE code = '23'), NOW(), NOW()),
    ('Екатеринбург', (SELECT id FROM orng_catalog.regions WHERE code = '66'), NOW(), NOW()),
    ('Нижний Тагил', (SELECT id FROM orng_catalog.regions WHERE code = '66'), NOW(), NOW()),
    ('Каменск-Уральский', (SELECT id FROM orng_catalog.regions WHERE code = '66'), NOW(), NOW()),
    ('Казань', (SELECT id FROM orng_catalog.regions WHERE code = '16'), NOW(), NOW()),
    ('Набережные Челны', (SELECT id FROM orng_catalog.regions WHERE code = '16'), NOW(), NOW()),
    ('Нижний Новгород', (SELECT id FROM orng_catalog.regions WHERE code = '52'), NOW(), NOW()),
    ('Дзержинск', (SELECT id FROM orng_catalog.regions WHERE code = '52'), NOW(), NOW()),
    ('Самара', (SELECT id FROM orng_catalog.regions WHERE code = '63'), NOW(), NOW()),
    ('Тольятти', (SELECT id FROM orng_catalog.regions WHERE code = '63'), NOW(), NOW()),
    ('Сызрань', (SELECT id FROM orng_catalog.regions WHERE code = '63'), NOW(), NOW()),
    ('Челябинск', (SELECT id FROM orng_catalog.regions WHERE code = '74'), NOW(), NOW()),
    ('Магнитогорск', (SELECT id FROM orng_catalog.regions WHERE code = '74'), NOW(), NOW()),
    ('Новосибирск', (SELECT id FROM orng_catalog.regions WHERE code = '54'), NOW(), NOW()),
    ('Волгоград', (SELECT id FROM orng_catalog.regions WHERE code = '34'), NOW(), NOW()),
    ('Волжский', (SELECT id FROM orng_catalog.regions WHERE code = '34'), NOW(), NOW()),
    ('Ростов-на-Дону', (SELECT id FROM orng_catalog.regions WHERE code = '61'), NOW(), NOW()),
    ('Таганрог', (SELECT id FROM orng_catalog.regions WHERE code = '61'), NOW(), NOW()),
    ('Красноярск', (SELECT id FROM orng_catalog.regions WHERE code = '24'), NOW(), NOW()),
    ('Норильск', (SELECT id FROM orng_catalog.regions WHERE code = '24'), NOW(), NOW()),
    ('Пермь', (SELECT id FROM orng_catalog.regions WHERE code = '59'), NOW(), NOW()),
    ('Воронеж', (SELECT id FROM orng_catalog.regions WHERE code = '36'), NOW(), NOW()),
    ('Саратов', (SELECT id FROM orng_catalog.regions WHERE code = '64'), NOW(), NOW()),
    ('Уфа', (SELECT id FROM orng_catalog.regions WHERE code = '02'), NOW(), NOW()),
    ('Стерлитамак', (SELECT id FROM orng_catalog.regions WHERE code = '02'), NOW(), NOW()),
    ('Махачкала', (SELECT id FROM orng_catalog.regions WHERE code = '05'), NOW(), NOW()),
    ('Дербент', (SELECT id FROM orng_catalog.regions WHERE code = '05'), NOW(), NOW()),
    ('Омск', (SELECT id FROM orng_catalog.regions WHERE code = '55'), NOW(), NOW()),
    ('Кемерово', (SELECT id FROM orng_catalog.regions WHERE code = '42'), NOW(), NOW()),
    ('Новокузнецк', (SELECT id FROM orng_catalog.regions WHERE code = '42'), NOW(), NOW()),
    ('Якутск', (SELECT id FROM orng_catalog.regions WHERE code = '14'), NOW(), NOW()),
    ('Хабаровск', (SELECT id FROM orng_catalog.regions WHERE code = '27'), NOW(), NOW()),
    ('Комсомольск-на-Амуре', (SELECT id FROM orng_catalog.regions WHERE code = '27'), NOW(), NOW()),
    ('Владивосток', (SELECT id FROM orng_catalog.regions WHERE code = '25'), NOW(), NOW()),
    ('Находка', (SELECT id FROM orng_catalog.regions WHERE code = '25'), NOW(), NOW()),
    ('Тюмень', (SELECT id FROM orng_catalog.regions WHERE code = '72'), NOW(), NOW()),
    ('Иркутск', (SELECT id FROM orng_catalog.regions WHERE code = '38'), NOW(), NOW()),
    ('Ульяновск', (SELECT id FROM orng_catalog.regions WHERE code = '73'), NOW(), NOW()),
    ('Брянск', (SELECT id FROM orng_catalog.regions WHERE code = '32'), NOW(), NOW()),
    ('Ярославль', (SELECT id FROM orng_catalog.regions WHERE code = '76'), NOW(), NOW()),
    ('Симферополь', (SELECT id FROM orng_catalog.regions WHERE code = '91'), NOW(), NOW()),
    ('Керчь', (SELECT id FROM orng_catalog.regions WHERE code = '91'), NOW(), NOW()),
    ('Севастополь', (SELECT id FROM orng_catalog.regions WHERE code = '92'), NOW(), NOW())
ON CONFLICT DO NOTHING;

INSERT INTO orng_schedule.shifts
(office_id, employee_id, scheduled_on, start_at, end_at)
SELECT
    1 AS office_id,
    e.employee_id AS employee_id,
    d::date AS scheduled_on,
    (CASE 
         WHEN RANDOM() < 0.95 THEN 9
         ELSE 10 + FLOOR(RANDOM() * 2)
     END || ':00')::time AS start_at,
    (CASE 
         WHEN RANDOM() < 0.95 THEN 16
         ELSE 17 + FLOOR(RANDOM() * 2)
     END || ':00')::time AS end_at
FROM generate_series('2026-02-01'::date, '2026-03-30'::date, interval '1 day') d
CROSS JOIN generate_series(3, 40, 2) e(employee_id)
WHERE EXTRACT(ISODOW FROM d) BETWEEN 1 AND 5
  AND RANDOM() < 0.6
ON CONFLICT DO NOTHING;

INSERT INTO orng_schedule.shifts
(office_id, employee_id, scheduled_on, start_at, end_at)
SELECT
    2 AS office_id,
    e.employee_id AS employee_id,
    d::date AS scheduled_on,
    (CASE 
         WHEN RANDOM() < 0.95 THEN 9
         ELSE 10 + FLOOR(RANDOM() * 2)
     END || ':00')::time AS start_at,
    (CASE 
         WHEN RANDOM() < 0.95 THEN 16
         ELSE 17 + FLOOR(RANDOM() * 2)
     END || ':00')::time AS end_at
FROM generate_series('2026-02-01'::date, '2026-03-30'::date, interval '1 day') d
CROSS JOIN generate_series(4, 40, 2) e(employee_id)
WHERE EXTRACT(ISODOW FROM d) BETWEEN 0 AND 5
AND RANDOM() < 0.6
ON CONFLICT DO NOTHING;

INSERT INTO orng_schedule.shifts
(office_id, employee_id, scheduled_on, start_at, end_at)
SELECT
    2 AS office_id,
    e.employee_id AS employee_id,
    d::date AS scheduled_on,
    TIME '10:00' AS start_at,
    TIME '16:00' AS end_at
FROM generate_series('2026-02-01'::date, '2026-03-30'::date, interval '1 day') d
CROSS JOIN (
    VALUES (3), (5), (9), (11), (23)
) AS e(employee_id)
WHERE EXTRACT(ISODOW FROM d) BETWEEN 0 AND 6
  AND RANDOM() < 0.6
ON CONFLICT DO NOTHING;

INSERT INTO orng_schedule.shifts
(office_id, employee_id, scheduled_on, start_at, end_at)
SELECT
    1 AS office_id,
    e.employee_id AS employee_id,
    d::date AS scheduled_on,
    TIME '10:00' AS start_at,
    TIME '16:00' AS end_at
FROM generate_series('2026-02-01'::date, '2026-03-30'::date, interval '1 day') d
CROSS JOIN (
    VALUES (4), (8), (6), (10), (14)
) AS e(employee_id)
WHERE EXTRACT(ISODOW FROM d) BETWEEN 0 AND 5
  AND RANDOM() < 0.6
ON CONFLICT DO NOTHING;

INSERT INTO orng_schedule.absences
(employee_id, absence_type_id, absent_on)
VALUES
(5,  1, '2026-02-10'),
(5,  1, '2026-02-11'),
(5,  1, '2026-02-12'),
(5,  1, '2026-02-13'),
(5,  1, '2026-02-14'),
(4,  1, '2026-02-02'),
(4,  1, '2026-02-03'),
(4,  1, '2026-02-04'),
(4,  1, '2026-02-05'),
(24,  1, '2026-02-16'),
(24,  1, '2026-02-17'),
(24,  1, '2026-02-18'),
(24,  1, '2026-02-19'),
(24,  1, '2026-02-20'),
(24, 1, '2026-02-21'),
(13, 1, '2026-02-20'),
(13,  1, '2026-02-21'),
(13,  1, '2026-02-22'),
(13,  1, '2026-02-23'),
(13,  1, '2026-02-24'),
(13,  1, '2026-02-25'),
(13, 1, '2026-02-26'),
(8,  2, '2026-02-18'),
(9,  2, '2026-02-19'),
(10,  2, '2026-02-10'),
(15,  2, '2026-02-13'),
(9,  2, '2026-02-4'),
(27, 2, '2026-02-20'),
(9,  2, '2026-02-6'),
(9,  2, '2026-02-3')
ON CONFLICT DO NOTHING;

delete from orng_schedule.shifts s
where s.id in (select s.id
from orng_schedule.shifts s
join orng_schedule.absences a
  on a.employee_id = s.employee_id
 and a.absent_on = s.scheduled_on);

delete from orng_schedule.shifts s
where s.id in (SELECT t.id
FROM (
    SELECT s.*,
           ROW_NUMBER() OVER (
               PARTITION BY s.employee_id, s.scheduled_on
               ORDER BY s.id
           ) AS rn
    FROM orng_schedule.shifts s
) t
WHERE rn = 2
  AND (SELECT COUNT(*) 
       FROM orng_schedule.shifts s2
       WHERE s2.employee_id = t.employee_id
         AND s2.scheduled_on = t.scheduled_on) > 1);

INSERT INTO orng_application.statuses (code, name)
VALUES ('IN_PROGRESS', 'В работе'),
       ('CLOSED', 'Завершённая'),
       ('REJECTED', 'Отклонённая'),
       ('OVERDUE', 'Просроченная')
ON CONFLICT (code) DO NOTHING;

WITH s AS (
    SELECT id, code
    FROM orng_application.statuses
    WHERE code IN ('IN_PROGRESS', 'CLOSED', 'REJECTED', 'OVERDUE')
),
ins AS (
    INSERT INTO orng_application.applications (office_id, region_id, status_id, created_at, updated_at)
    VALUES
        (1, 1, (SELECT id FROM s WHERE code = 'IN_PROGRESS'), '2026-02-03 09:15:00+02', '2026-02-03 09:15:00+02'),
        (1, 1, (SELECT id FROM s WHERE code = 'OVERDUE'),     '2026-02-19 11:10:00+02', '2026-02-25 18:30:00+02'),
        (2, 1, (SELECT id FROM s WHERE code = 'CLOSED'),      '2026-02-05 10:00:00+02', '2026-02-08 12:00:00+02'),
        (2, 1, (SELECT id FROM s WHERE code = 'REJECTED'),    '2026-02-12 14:20:00+02', '2026-02-12 16:00:00+02')
    RETURNING id, office_id, status_id
)
INSERT INTO orng_application.application_records
    (application_id, position_id, quantity, start_on, end_on, start_at, end_at)
SELECT i.id, r.position_id, r.quantity, r.start_on, r.end_on, r.start_at, r.end_at
FROM ins i
JOIN LATERAL (
    SELECT *
    FROM (
        SELECT 2::bigint AS position_id, 2::int AS quantity,
               '2026-02-10'::date AS start_on, '2026-02-14'::date AS end_on,
               '09:00'::time AS start_at, '18:00'::time AS end_at
        WHERE i.office_id = 1 AND i.status_id = (SELECT id FROM s WHERE code = 'IN_PROGRESS')
        UNION ALL
        SELECT 3::bigint, 1::int,
               '2026-02-15'::date, '2026-02-18'::date,
               '10:00'::time, '16:00'::time
        WHERE i.office_id = 1 AND i.status_id = (SELECT id FROM s WHERE code = 'IN_PROGRESS')
        UNION ALL
        SELECT 6::bigint, 1::int,
               '2026-02-20'::date, '2026-02-22'::date,
               '09:00'::time, '18:00'::time
        WHERE i.office_id = 1 AND i.status_id = (SELECT id FROM s WHERE code = 'OVERDUE')
        UNION ALL
        SELECT 2::bigint, 3::int,
               '2026-02-05'::date, '2026-02-07'::date,
               '10:00'::time, '16:00'::time
        WHERE i.office_id = 2 AND i.status_id = (SELECT id FROM s WHERE code = 'CLOSED')
        UNION ALL
        SELECT 4::bigint, 1::int,
               '2026-02-12'::date, '2026-02-12'::date,
               '09:00'::time, '18:00'::time
        WHERE i.office_id = 2 AND i.status_id = (SELECT id FROM s WHERE code = 'REJECTED')
    ) t
) r ON TRUE
ON CONFLICT DO NOTHING;