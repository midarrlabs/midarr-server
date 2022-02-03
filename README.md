> **EARLY PREVIEW SOFTWARE** -
> Please beware this is early preview software in rapid development, there will be bugs!
>
> Please show your support by:
> * Using the software
> * Reporting bugs and issues
> * Being kind and patient with the development process
>
> Enjoy 🎉

![Preview](docs/Midarr-light.png)

<div align="center">
    <a href="https://github.com/midarrlabs/midarr-server/actions/workflows/master.yml"><img src="https://github.com/midarrlabs/midarr-server/actions/workflows/master.yml/badge.svg" alt="Build Status"></a>
</div>

`Midarr` has arrived and aims to provide a media experience like none other:

* Beautifully crafted interface to enhance your viewing experience
* Social from the get go - user online and watch statuses
* User invitations to share the experience
* Integrations with Radarr and Sonarr

with plenty more to come...

![Preview](docs/home.png)

#### What is this?

`Midarr` in its' current preview form, is a lightweight (albeit companion) media server to the likes of Radarr and Sonarr. It relies on the integration with these services to serve your **MP4** format media untouched and unscathed.

While more fully fledged media server options already exist, `Midarr` simply compliments as a lightweight alternative.

#### What does it not do?

`Midarr` currently does not:
* Index your media
* Transcode your media
* Edit or configure your media

#### What does it do?

Your media is retrieved and served through a familiar web interface and provides:
* User authentication
* User profile settings
* User online statuses

with more features planned ahead.

## Usage

Docker compose example:

```yaml
version: '3'

volumes:
  database-data:

services:
  midarr:
    image: ghcr.io/midarrlabs/midarr-server:latest
    depends_on:
      database:
        condition: service_healthy
    ports:
      - "4000:4000"
    volumes:
      - /path/to/radarr/movies:/movies
      - /path/to/sonarr/shows:/shows
    restart: unless-stopped

  database:
    image: bitnami/postgresql:14
    healthcheck:
      test: "exit 0"
    volumes:
      - database-data:/bitnami/postgresql
    ports:
      - 5432:5432
    environment:
      - POSTGRESQL_USERNAME=my_user
      - POSTGRESQL_PASSWORD=password123
      - POSTGRESQL_DATABASE=my_database
```

## Configuration

Integrations must also provide the volumes as mounted in your Radarr and Sonarr instances:
```bash
/path/to/radarr/movies:/movies
/path/to/sonarr/shows:/shows
```
This is so `Midarr` has the same reference to your media library as the integrations, and can find them.

## Gotchas

#### Media codec support
* Video H264
* Audio AAC / MP3
* Container MP4

#### Server setup

There is currently no initial server setup for walking through setting everything up, including the first user / admin account.

You must manually setup the first user account by inserting an entry into the postgres database, and setting the `is_admin` flag to `true`.
Use https://bcrypt-generator.com/ to encrypt your password.

Using the admin account, go to the `Settings` page to configure your integration.

## Contributing

Thank you for your contributions! Big or small - we welcome all!

## License

`Midarr` is open-sourced software licensed under the [MIT license](LICENSE).

## Screenshots

![Preview](docs/online.png)
![Preview](docs/series.png)
![Preview](docs/movie.png)
![Preview](docs/player.png)