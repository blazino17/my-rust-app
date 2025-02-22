use actix_web::{web, App, HttpServer, Responder};

async fn index() -> impl Responder {
    "Hello, world!"
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(index))
    })
    .bind("0.0.0.0:8080")?  // Ensure the application listens on 0.0.0.0
    .run()
    .await
}

