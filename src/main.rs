use std::env;

use sqlx::{migrate::MigrateDatabase, sqlite::{SqliteConnectOptions, SqliteJournalMode}, Error, Sqlite, SqlitePool};

mod models;

#[tokio::main]
async fn main() -> Result<(), Error> {

    let database_path = env::var("DATABASE_URL").unwrap();

    if !Sqlite::database_exists(&database_path).await? {
        Sqlite::create_database(&database_path).await?;
    }
    
    let opts = SqliteConnectOptions::new()
        .journal_mode(SqliteJournalMode::Wal)
        .foreign_keys(true)
        .filename(database_path);

    let pool = SqlitePool::connect_lazy_with(opts);

    sqlx::migrate!().run(&pool).await?;

    println!("{:?}", pool);
    
    Ok(())
}
