<p align="center">
    <img src="priv/static/logo.svg" width="150" height="150" alt="logo">
</p>

<p align="center">
    <a href="https://github.com/midarrlabs/midarr-server/actions/workflows/master.yml">
        <img src="https://github.com/midarrlabs/midarr-server/actions/workflows/master.yml/badge.svg" alt="Build Status">
    </a>
    <a href="https://codecov.io/gh/midarrlabs/midarr-server">
        <img src="https://codecov.io/gh/midarrlabs/midarr-server/branch/master/graph/badge.svg?token=8PJVJG09RK"/>
    </a>
    <a href="https://github.com/midarrlabs/midarr-server/releases">
        <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/midarrlabs/midarr-server">
    </a>
    <a href="https://github.com/midarrlabs/midarr-server/blob/master/LICENSE">
        <img alt="GitHub license" src="https://img.shields.io/github/license/midarrlabs/midarr-server">
    </a>
</p>

`Midarr` is a minimal lightweight media server for enjoying your media:

* Free and open source
* Beautifully crafted user interface
* Real-time online statuses
* Simple and easy invite system
* Integrates with your existing services, [Radarr](https://radarr.video/) and [Sonarr](https://sonarr.tv/)

with much more to come...

![Preview](docs/home-v1.15.0.png)

#### What is this?

`Midarr` in its' current form, is a lightweight (albeit companion) media server to the likes of Radarr and Sonarr. It relies on the integration with these services to serve your **H.264** codec media untouched and unscathed.

While more fully fledged media server options already exist, `Midarr` simply compliments as a lightweight alternative.

#### What's lightweight about it?

`Midarr` does not:

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
services:
  
  midarr:
    container_name: midarr
    image: ghcr.io/midarrlabs/midarr-server:latest
    ports:
      - 4000:4000
    volumes:
      - /path/to/movies:/radarr/movies/path
      - /path/to/shows:/sonarr/shows/path
    environment:
#       App config
      - APP_URL=http://localhost:4000
      - APP_MAILER_FROM=example@email.com

#       Initialise admin account
      - SETUP_ADMIN_EMAIL=admin@email.com
      - SETUP_ADMIN_NAME=admin
      - SETUP_ADMIN_PASSWORD=passwordpassword # minimum length 12

#       Radarr integration
      - RADARR_BASE_URL=radarr:7878
      - RADARR_API_KEY=someApiKey

#       Sonarr integration
      - SONARR_BASE_URL=sonarr:8989
      - SONARR_API_KEY=someApiKey
        
#       Sendgrid email integration
      - SENDGRID_API_KEY=someApiKey
```

## Configuration

#### Volumes

Volumes must be provided as mounted in your Radarr and Sonarr instances:

```yaml
volumes:
  - /path/to/movies:/radarr/movies/path
  - /path/to/shows:/sonarr/shows/path
```
This is so `Midarr` has the same reference to your media library as your integrations, and can serve them.

#### Initialise admin account

An admin account will be initialised for you on server startup, provided you have these `environment` variables configured:

```yaml
environment:
  - SETUP_ADMIN_EMAIL=admin@email.com
  - SETUP_ADMIN_NAME=admin
  - SETUP_ADMIN_PASSWORD=passwordpassword # minimum length 12
```
Login with these credentials, and access the `Settings` page to configure your server.

## Support

#### Videos

The following video format is currently supported:

* H.264 codec
* AAC / MP3 audio
* MP4 / MKV container

#### Subtitles

A single `*.srt` file in the root directory of the video is currently supported:

```
videos/some-video
      └── some-video.mp4
      └── some-video.srt
```
With this setup a subtitle / caption option will be available in the player view.

## Contributing

Thank you for all your contributions! Big or small - all is welcome!

#### Local development

Setting up your local development environment is easy and only a few steps:

1. Fork and git clone the repository

```shell
git clone https://github.com/{ YOUR-ACCOUNT }/midarr-server.git
```

2. Docker compose up the stack

```shell
docker compose up -d
```

3. Bash into `Midarr` container

```shell
docker exec -it midarr bash
```

4. Run the tests to seed fixtures

```shell
MIX_ENV=test mix test
```

Your local environment is now setup for development:
- [http://localhost:4000](http://localhost:4000) - Midarr
- [http://localhost:7878](http://localhost:7878) - Radarr
- [http://localhost:8989](http://localhost:8989) - Sonarr

## License

`Midarr` is open-sourced software licensed under the [MIT license](LICENSE).

## Preview

![Preview](docs/login-v1.4.0.png)
![Preview](docs/online-v1.6.1.png)
![Preview](docs/movie-v1.15.0.png)
![Preview](docs/player-v1.15.0.png)
