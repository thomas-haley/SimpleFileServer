CREATE TABLE [user] (
  [id] integer PRIMARY KEY,
  [name] string
)
GO

CREATE TABLE [promise] (
  [id] integer PRIMARY KEY,
  [title] string,
  [description] string,
  [collection_id] int,
  [deadline] datetime,
  [deadline_reminder_range] string,
  [deadline_reminder_rate] integer,
  [period_range] string,
  [period_rate] int,
  [priority] int,
  [created_user] int
)
GO

CREATE TABLE [promise_collection] (
  [id] integer PRIMARY KEY,
  [collection_id] integer,
  [name] string
)
GO

CREATE TABLE [user_promise] (
  [user_id] integer,
  [promise_id] integer,
  [accepted] boolean
)
GO

CREATE TABLE [active_promise] (
  [user_id] integer,
  [promise_id] integer,
  [promise_range_id] integer,
  [accepted] boolean,
  [assigned] datetime,
  [deadline] datetime,
  [completed] datetime
)
GO

CREATE TABLE [user_promise_range] (
  [id] integer PRIMARY KEY,
  [user] integer,
  [start_range] datetime,
  [end_range] datetime,
  [repeat] string,
  [prefer_start] boolean,
  [max_tasks] integer
)
GO

ALTER TABLE [promise] ADD FOREIGN KEY ([collection_id]) REFERENCES [promise_collection] ([id])
GO

ALTER TABLE [promise] ADD FOREIGN KEY ([created_user]) REFERENCES [user] ([id])
GO

ALTER TABLE [user_promise] ADD FOREIGN KEY ([user_id]) REFERENCES [user] ([id])
GO

ALTER TABLE [user_promise] ADD FOREIGN KEY ([promise_id]) REFERENCES [promise] ([id])
GO

ALTER TABLE [active_promise] ADD FOREIGN KEY ([user_id]) REFERENCES [user] ([id])
GO

ALTER TABLE [active_promise] ADD FOREIGN KEY ([promise_id]) REFERENCES [promise] ([id])
GO

ALTER TABLE [active_promise] ADD FOREIGN KEY ([promise_range_id]) REFERENCES [user_promise_range] ([id])
GO

ALTER TABLE [user_promise_range] ADD FOREIGN KEY ([user]) REFERENCES [user] ([id])
GO
