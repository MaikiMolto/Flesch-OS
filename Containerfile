# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# ── Base Image ──────────────────────────────────────────────────────────────
# Bazzite KDE mit Nvidia-Treibern (RTX 4090 / RTX Series)
FROM ghcr.io/ublue-os/bazzite-nvidia:stable

### MODIFICATIONS
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

### LINTING
RUN bootc container lint
