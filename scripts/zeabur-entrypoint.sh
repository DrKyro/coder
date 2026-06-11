#!/bin/sh
set -eu

if [ -z "${CODER_HTTP_ADDRESS:-}" ]; then
	PORT="${PORT:-8080}"
	export CODER_HTTP_ADDRESS="0.0.0.0:${PORT}"
fi

if [ -z "${CODER_ACCESS_URL:-}" ]; then
	if [ -n "${ZEABUR_WEB_URL:-}" ]; then
		export CODER_ACCESS_URL="${ZEABUR_WEB_URL%/}"
	elif [ -n "${ZEABUR_PUBLIC_DOMAIN:-}" ]; then
		export CODER_ACCESS_URL="https://${ZEABUR_PUBLIC_DOMAIN}"
	elif [ -n "${ZEABUR_DOMAIN:-}" ]; then
		export CODER_ACCESS_URL="https://${ZEABUR_DOMAIN}"
	elif [ -n "${ZEABUR_WEB_DOMAIN:-}" ]; then
		export CODER_ACCESS_URL="https://${ZEABUR_WEB_DOMAIN}"
	fi
fi

if [ -z "${CODER_PG_CONNECTION_URL:-}" ]; then
	if [ -n "${POSTGRES_URI:-}" ]; then
		export CODER_PG_CONNECTION_URL="${POSTGRES_URI}"
	elif [ -n "${POSTGRES_CONNECTION_STRING:-}" ]; then
		export CODER_PG_CONNECTION_URL="${POSTGRES_CONNECTION_STRING}"
	elif [ -n "${POSTGRESQL_CONNECTION_STRING:-}" ]; then
		export CODER_PG_CONNECTION_URL="${POSTGRESQL_CONNECTION_STRING}"
	elif [ -n "${POSTGRES_URL:-}" ]; then
		export CODER_PG_CONNECTION_URL="${POSTGRES_URL}"
	elif [ -n "${POSTGRESQL_URL:-}" ]; then
		export CODER_PG_CONNECTION_URL="${POSTGRESQL_URL}"
	elif [ -n "${DATABASE_URL:-}" ]; then
		export CODER_PG_CONNECTION_URL="${DATABASE_URL}"
	fi
fi

if [ -n "${CODER_PG_CONNECTION_URL:-}" ]; then
	case "${CODER_PG_CONNECTION_URL}" in
		*sslmode=*) ;;
		*\?*) export CODER_PG_CONNECTION_URL="${CODER_PG_CONNECTION_URL}&sslmode=disable" ;;
		*) export CODER_PG_CONNECTION_URL="${CODER_PG_CONNECTION_URL}?sslmode=disable" ;;
	esac
fi

exec /opt/coder server "$@"
