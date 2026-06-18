IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Role] (
        [RoleID] varchar(20) NOT NULL,
        [RoleName] nvarchar(100) NOT NULL,
        [RoleDescription] nvarchar(255) NULL,
        CONSTRAINT [PK__Role__8AFACE3A872501E5] PRIMARY KEY ([RoleID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Service] (
        [ServiceID] int NOT NULL IDENTITY,
        [Name] nvarchar(100) NULL,
        [Description] nvarchar(max) NULL,
        [Price] decimal(10,2) NULL,
        CONSTRAINT [PK__Service__C51BB0EA63AB2E89] PRIMARY KEY ([ServiceID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Specialty] (
        [SpecialtyID] int NOT NULL IDENTITY,
        [Name] nvarchar(50) NULL,
        [Description] nvarchar(max) NULL,
        [IsDeleted] bit NOT NULL,
        CONSTRAINT [PK__Specialt__D768F6489A0BBC10] PRIMARY KEY ([SpecialtyID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [User] (
        [UserID] int NOT NULL IDENTITY,
        [Provider] nvarchar(max) NULL,
        [GoogleId] nvarchar(max) NULL,
        [FullName] nvarchar(50) NULL,
        [PasswordHash] varchar(100) NULL,
        [Email] varchar(100) NOT NULL,
        [PhoneNumber] varchar(15) NULL,
        [DoB] date NULL,
        [Gender] nvarchar(15) NULL,
        [Address] nvarchar(100) NULL,
        [CreateDate] date NULL DEFAULT ((getdate())),
        [Avatar] varchar(200) NULL,
        [RoleID] varchar(20) NULL,
        [RefreshToken] nvarchar(max) NULL,
        [RefreshTokenExpiryTime] datetime2 NULL,
        [IsAvailable] bit NOT NULL,
        CONSTRAINT [PK__User__1788CCAC907AF080] PRIMARY KEY ([UserID]),
        CONSTRAINT [FK__User__RoleID__286302EC] FOREIGN KEY ([RoleID]) REFERENCES [Role] ([RoleID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [ReportServiceDetail] (
        [ReportServiceID] int NOT NULL IDENTITY,
        [ReportPeriod] nvarchar(20) NULL,
        [ServiceID] int NULL,
        [UsageCount] int NULL,
        [AvgRating] decimal(10,2) NULL,
        [TotalRevenue] decimal(10,2) NULL,
        [CreatedAt] datetime NULL,
        CONSTRAINT [PK__ReportSe__EBE898635120F25D] PRIMARY KEY ([ReportServiceID]),
        CONSTRAINT [FK__ReportSer__Servi__4222D4EF] FOREIGN KEY ([ServiceID]) REFERENCES [Service] ([ServiceID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Appointment] (
        [AppointmentID] int NOT NULL IDENTITY,
        [MemberID] int NOT NULL,
        [MeetLink] varchar(50) NULL,
        [ServiceID] int NULL,
        [ConsultantID] int NULL,
        [StartTime] datetime NULL,
        [EndTime] datetime NULL,
        [Status] nvarchar(20) NULL,
        [Symptoms] nvarchar(max) NULL,
        CONSTRAINT [PK__Appointm__8ECDFCA2D172AD9E] PRIMARY KEY ([AppointmentID]),
        CONSTRAINT [FK__Appointme__Consu__3F466844] FOREIGN KEY ([ConsultantID]) REFERENCES [User] ([UserID]),
        CONSTRAINT [FK__Appointme__Membe__3D5E1FD2] FOREIGN KEY ([MemberID]) REFERENCES [User] ([UserID]) ON DELETE CASCADE,
        CONSTRAINT [FK__Appointme__Servi__3E52440B] FOREIGN KEY ([ServiceID]) REFERENCES [Service] ([ServiceID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Blog] (
        [BlogID] int NOT NULL IDENTITY,
        [Title] nvarchar(200) NULL,
        [Content] nvarchar(max) NULL,
        [Description] nvarchar(max) NULL,
        [ConsultantID] int NULL,
        [PublishDate] date NULL,
        [Topic] nvarchar(50) NULL,
        [Status] bit NOT NULL,
        CONSTRAINT [PK__Blog__54379E5044619794] PRIMARY KEY ([BlogID]),
        CONSTRAINT [FK__Blog__Consultant__34C8D9D1] FOREIGN KEY ([ConsultantID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Notification] (
        [NotificationID] int NOT NULL IDENTITY,
        [UserID] int NULL,
        [Title] nvarchar(50) NULL,
        [Content] nvarchar(max) NULL,
        [SendTime] datetime NULL,
        [IsRead] bit NULL,
        CONSTRAINT [PK__Notifica__20CF2E325DAFA885] PRIMARY KEY ([NotificationID]),
        CONSTRAINT [FK__Notificat__UserI__4BAC3F29] FOREIGN KEY ([UserID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [OTPRequest] (
        [OTPID] int NOT NULL IDENTITY,
        [UserID] int NULL,
        [Code] varchar(15) NULL,
        [Email] varchar(100) NULL,
        [CreatedAt] datetime NULL,
        [ExpiredAt] datetime NULL,
        [IsVerified] int NULL,
        CONSTRAINT [PK__OTPReque__5C2EC562B070925E] PRIMARY KEY ([OTPID]),
        CONSTRAINT [FK__OTPReques__UserI__48CFD27E] FOREIGN KEY ([UserID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Question] (
        [QuestionID] int NOT NULL IDENTITY,
        [MemberID] int NULL,
        [SpecialtyId] int NULL,
        [TitleQuestion] nvarchar(200) NULL,
        [Content] nvarchar(max) NULL,
        [AttachmentPath] nvarchar(200) NULL,
        [SubmitDate] datetime NULL,
        [ConsultantID] int NULL,
        [Status] nvarchar(100) NULL,
        [Age] int NULL,
        [Gender] nvarchar(max) NULL,
        [Heart] bit NULL,
        [AnsCount] int NULL,
        CONSTRAINT [PK__Question__0DC06F8C7085B3FF] PRIMARY KEY ([QuestionID]),
        CONSTRAINT [FK_Question_Specialty_SpecialtyId] FOREIGN KEY ([SpecialtyId]) REFERENCES [Specialty] ([SpecialtyID]),
        CONSTRAINT [FK__Question__Consul__45F365D3] FOREIGN KEY ([ConsultantID]) REFERENCES [User] ([UserID]),
        CONSTRAINT [FK__Question__Member__44FF419A] FOREIGN KEY ([MemberID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [ReproductiveCycle] (
        [CycleID] int NOT NULL IDENTITY,
        [MemberID] int NOT NULL,
        [StartDate] date NULL,
        [CycleLength] int NULL,
        [PeriodLength] int NULL,
        [PillTime] time NULL,
        [LastUpdated] datetime NULL,
        CONSTRAINT [PK__Reproduc__077B24D97C9AA5A6] PRIMARY KEY ([CycleID]),
        CONSTRAINT [FK__Reproduct__Membe__2F10007B] FOREIGN KEY ([MemberID]) REFERENCES [User] ([UserID]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [TestServiceRecord] (
        [TestServiceRecordID] int NOT NULL IDENTITY,
        [ServiceID] int NULL,
        [Dob] date NULL,
        [Gender] varchar(15) NULL,
        [PhoneNumber] varchar(15) NULL,
        [FullNameOfMember] nvarchar(100) NULL,
        [MemberID] int NULL,
        [Result] nvarchar(100) NULL,
        [StaffID] int NULL,
        [RecordDate] datetime NULL,
        [TestDate] date NULL,
        [TimeSlot] TIME NULL,
        [Notes] nvarchar(100) NULL,
        [Status] nvarchar(50) NULL,
        CONSTRAINT [PK__TestServ__F810175D4779B45B] PRIMARY KEY ([TestServiceRecordID]),
        CONSTRAINT [FK__TestServi__Membe__398D8EEE] FOREIGN KEY ([MemberID]) REFERENCES [User] ([UserID]),
        CONSTRAINT [FK__TestServi__Servi__38996AB5] FOREIGN KEY ([ServiceID]) REFERENCES [Service] ([ServiceID]),
        CONSTRAINT [FK__TestServi__Staff__3A81B327] FOREIGN KEY ([StaffID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [UserSpecialty] (
        [UserID] int NOT NULL,
        [SpecialtyID] int NOT NULL,
        CONSTRAINT [PK__UserSpec__8AFE43C8943BFACE] PRIMARY KEY ([UserID], [SpecialtyID]),
        CONSTRAINT [FK__UserSpeci__Speci__4F7CD00D] FOREIGN KEY ([SpecialtyID]) REFERENCES [Specialty] ([SpecialtyID]),
        CONSTRAINT [FK__UserSpeci__UserI__4E88ABD4] FOREIGN KEY ([UserID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [WeeklyOverrideSchedules] (
        [WeeklyOverrideScheduleId] int NOT NULL IDENTITY,
        [UserId] int NOT NULL,
        [Date] datetime2 NOT NULL,
        [OverrideType] nvarchar(max) NULL,
        [Reason] nvarchar(max) NULL,
        [ShiftType] int NULL,
        [Status] nvarchar(30) NOT NULL,
        CONSTRAINT [PK_WeeklyOverrideSchedules] PRIMARY KEY ([WeeklyOverrideScheduleId]),
        CONSTRAINT [FK_WeeklyOverrideSchedules_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [User] ([UserID]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [WeeklySchedules] (
        [WeeklyScheduleId] int NOT NULL IDENTITY,
        [UserId] int NOT NULL,
        [DayOfWeek] int NOT NULL,
        [StartTime] TIME NOT NULL,
        [EndTime] TIME NOT NULL,
        [ShiftType] int NOT NULL,
        [Note] nvarchar(max) NULL,
        CONSTRAINT [PK_WeeklySchedules] PRIMARY KEY ([WeeklyScheduleId]),
        CONSTRAINT [FK_WeeklySchedules_User_UserId] FOREIGN KEY ([UserId]) REFERENCES [User] ([UserID]) ON DELETE CASCADE
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [BlogImage] (
        [ImageID] int NOT NULL IDENTITY,
        [BlogID] int NULL,
        [ImagePath] varchar(200) NULL,
        [ImageCaption] nvarchar(200) NULL,
        [UploadDate] datetime NULL,
        [OrderIndex] int NULL,
        CONSTRAINT [PK__BlogImag__7516F4EC111C0B4F] PRIMARY KEY ([ImageID]),
        CONSTRAINT [FK__BlogImage__BlogI__59063A47] FOREIGN KEY ([BlogID]) REFERENCES [Blog] ([BlogID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [BlogView] (
        [BlogViewID] int NOT NULL IDENTITY,
        [MemberID] int NULL,
        [BlogID] int NULL,
        [ViewDate] datetime NULL,
        CONSTRAINT [PK__BlogView__5A5F0B6CFF67BCB5] PRIMARY KEY ([BlogViewID]),
        CONSTRAINT [FK__BlogView__BlogID__5CD6CB2B] FOREIGN KEY ([BlogID]) REFERENCES [Blog] ([BlogID]),
        CONSTRAINT [FK__BlogView__Member__5BE2A6F2] FOREIGN KEY ([MemberID]) REFERENCES [User] ([UserID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [QuestionThreadItem] (
        [ThreadItemID] int NOT NULL IDENTITY,
        [QuestionID] int NULL,
        [SentAt] datetime NULL,
        [AnsweredAt] datetime NULL,
        [QuestionText] nvarchar(max) NULL,
        [AnswerText] nvarchar(max) NULL,
        [AttachmentPath] nvarchar(255) NULL,
        [IsAnswered] bit NULL,
        CONSTRAINT [PK__QuestionThreadItem] PRIMARY KEY ([ThreadItemID]),
        CONSTRAINT [FK__QuestionThreadItem__Question] FOREIGN KEY ([QuestionID]) REFERENCES [Question] ([QuestionID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Feedback] (
        [FeedbackID] int NOT NULL IDENTITY,
        [AppointmentID] int NULL,
        [RecordID] int NULL,
        [Rating] int NULL,
        [Comment] nvarchar(max) NULL,
        [FeedbackDate] datetime NULL DEFAULT ((getdate())),
        CONSTRAINT [PK__Feedback__6A4BEDF62A9CAF58] PRIMARY KEY ([FeedbackID]),
        CONSTRAINT [FK__Feedback__Appoin__656C112C] FOREIGN KEY ([AppointmentID]) REFERENCES [Appointment] ([AppointmentID]),
        CONSTRAINT [FK__Feedback__Record__66603565] FOREIGN KEY ([RecordID]) REFERENCES [TestServiceRecord] ([TestServiceRecordID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE TABLE [Invoice] (
        [InvoiceID] int NOT NULL IDENTITY,
        [AppointmentID] int NULL,
        [TestServiceRecordID] int NULL,
        [TotalAmount] decimal(10,2) NULL,
        [PaymentMethod] varchar(50) NULL,
        [TransactionId] varchar(100) NULL,
        [CreatedAt] datetime NULL,
        [Status] int NULL,
        [TaxRate] decimal(10,2) NULL,
        [UnitPrice] varchar(15) NULL,
        [PaidAt] datetime NULL,
        CONSTRAINT [PK__Invoice__D796AAD50B806764] PRIMARY KEY ([InvoiceID]),
        CONSTRAINT [FK__Invoice__Appoint__5441852A] FOREIGN KEY ([AppointmentID]) REFERENCES [Appointment] ([AppointmentID]),
        CONSTRAINT [FK__Invoice__TestSer__5535A963] FOREIGN KEY ([TestServiceRecordID]) REFERENCES [TestServiceRecord] ([TestServiceRecordID])
    );
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Appointment_ConsultantID] ON [Appointment] ([ConsultantID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Appointment_MemberID] ON [Appointment] ([MemberID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Appointment_ServiceID] ON [Appointment] ([ServiceID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Blog_ConsultantID] ON [Blog] ([ConsultantID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_BlogImage_BlogID] ON [BlogImage] ([BlogID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_BlogView_BlogID] ON [BlogView] ([BlogID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_BlogView_MemberID] ON [BlogView] ([MemberID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Feedback_AppointmentID] ON [Feedback] ([AppointmentID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Feedback_RecordID] ON [Feedback] ([RecordID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Invoice_AppointmentID] ON [Invoice] ([AppointmentID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Invoice_TestServiceRecordID] ON [Invoice] ([TestServiceRecordID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Notification_UserID] ON [Notification] ([UserID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_OTPRequest_UserID] ON [OTPRequest] ([UserID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Question_ConsultantID] ON [Question] ([ConsultantID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Question_MemberID] ON [Question] ([MemberID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_Question_SpecialtyId] ON [Question] ([SpecialtyId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_QuestionThreadItem_QuestionID] ON [QuestionThreadItem] ([QuestionID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_ReportServiceDetail_ServiceID] ON [ReportServiceDetail] ([ServiceID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_ReproductiveCycle_MemberID] ON [ReproductiveCycle] ([MemberID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_TestServiceRecord_MemberID] ON [TestServiceRecord] ([MemberID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_TestServiceRecord_ServiceID] ON [TestServiceRecord] ([ServiceID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_TestServiceRecord_StaffID] ON [TestServiceRecord] ([StaffID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_User_RoleID] ON [User] ([RoleID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_UserSpecialty_SpecialtyID] ON [UserSpecialty] ([SpecialtyID]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_WeeklyOverrideSchedules_UserId] ON [WeeklyOverrideSchedules] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    CREATE INDEX [IX_WeeklySchedules_UserId] ON [WeeklySchedules] ([UserId]);
END;

IF NOT EXISTS (
    SELECT * FROM [__EFMigrationsHistory]
    WHERE [MigrationId] = N'20250727154411_database'
)
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20250727154411_database', N'9.0.6');
END;

COMMIT;
GO

