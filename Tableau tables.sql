USE [practice];

IF SCHEMA_ID(N'igaming') IS NULL
    EXEC(N'CREATE SCHEMA igaming');

IF OBJECT_ID(N'igaming.players', N'U') IS NULL
CREATE TABLE igaming.players (
    player_id INT NOT NULL PRIMARY KEY,
    registration_date DATE NOT NULL,
    country VARCHAR(50) NOT NULL,
    acquisition_channel VARCHAR(30) NOT NULL
);

IF OBJECT_ID(N'igaming.games', N'U') IS NULL
CREATE TABLE igaming.games (
    game_id INT NOT NULL PRIMARY KEY,
    game_name VARCHAR(100) NOT NULL,
    game_category VARCHAR(30) NOT NULL
);

IF OBJECT_ID(N'igaming.calendar', N'U') IS NULL
CREATE TABLE igaming.calendar (
    [date] DATE NOT NULL PRIMARY KEY,
    [year] INT NOT NULL,
    [month] INT NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    is_weekend BIT NOT NULL
);

IF OBJECT_ID(N'igaming.payments', N'U') IS NULL
CREATE TABLE igaming.payments (
    payment_id INT NOT NULL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES igaming.players(player_id),
    submitted_at DATETIME2(0) NOT NULL,
    completed_at DATETIME2(0) NULL,
    payment_type VARCHAR(15) NOT NULL,
    provider VARCHAR(30) NOT NULL,
    [status] VARCHAR(15) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    currency CHAR(3) NOT NULL,
    CHECK (payment_type IN ('Deposit', 'Withdrawal')),
    CHECK ([status] IN ('Completed', 'Failed', 'Pending')),
    CHECK (amount > 0),
    CHECK (([status] = 'Completed' AND completed_at IS NOT NULL)
        OR ([status] IN ('Failed', 'Pending') AND completed_at IS NULL)),
    CHECK (completed_at IS NULL OR completed_at >= submitted_at)
);

IF OBJECT_ID(N'igaming.gaming_activity', N'U') IS NULL
CREATE TABLE igaming.gaming_activity (
    activity_id INT NOT NULL PRIMARY KEY,
    player_id INT NOT NULL REFERENCES igaming.players(player_id),
    activity_date DATE NOT NULL REFERENCES igaming.calendar([date]),
    game_id INT NOT NULL REFERENCES igaming.games(game_id),
    rounds INT NOT NULL CHECK (rounds > 0),
    stakes DECIMAL(18,2) NOT NULL CHECK (stakes >= 0),
    winnings DECIMAL(18,2) NOT NULL CHECK (winnings >= 0),
    currency CHAR(3) NOT NULL,
    UNIQUE (player_id, activity_date, game_id)
);

-- Verify that all five tables exist. They should be empty before CSV import.
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'igaming' AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
