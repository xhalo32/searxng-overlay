# SearXNG priv.au Nix Overlay

This repository is a Nix port of [privau/searxng](https://github.com/privau/searxng), a [SearXNG](https://github.com/searxng/searxng) "fork" with themes and other features.

In particular, this overlay provides various themes to SearXNG through `Preferences > User Interface > Theme style`.

This overlay also acts as a future reference for customizing SearXNG as the [How To Add Theme On SearXNG](https://github.com/searxng/searxng/discussions/3707) discussion doesn't provide any useful insight into how to customize and rebuild the stylesheets.

## Usage

Inputs (npins sources):
- `nixpkgs` (follows `nixos-unstable`)
- `searxng` (follows `searxng/searxng` master)
- `privau-searxng` (follows `privau/searxng` main)

To add this repository as an overlay, first add it as a source

```
npins add github xhalo32 searxng-overlay --branch main
```

To add the overlay to your pkgs with the (possibly outdated) sources provided by this repository, use

```nix
(final: prev: {
    inherit (import sources.searxng-overlay { }) searxng;
})
```

> If you want to inject your own dependencies, and your sources already contain `nixpkgs`, `searxng` and `privau-searxng`, use
> 
> ```nix
> (final: prev: {
>     inherit (import sources.searxng-overlay { inherit sources; }) searxng;
> })
> ```

To add `searxng` and `privau-searxng` as sources to your project, use

```
npins add github searxng searxng --branch master
npins add github privau searxng --branch main --name privau-searxng
```

## Background

To figure out how to rebuild the stylesheets I read throgh privau's [update.sh](https://github.com/privau/searxng/blob/d81eb1fba5285c3459067da504813571a2592d24/update.sh) and [Dockerfile](https://github.com/privau/searxng/blob/d81eb1fba5285c3459067da504813571a2592d24/Dockerfile).
The nix build runs the critical steps in these scripts.
