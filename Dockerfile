FROM ghcr.io/coder/coder:latest

USER root
COPY --chmod=755 scripts/zeabur-entrypoint.sh /opt/zeabur-entrypoint.sh
USER 1000:1000

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/opt/zeabur-entrypoint.sh"]
