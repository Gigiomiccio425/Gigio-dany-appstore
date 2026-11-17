# Sourced by umbrelOS. Do not add a shebang or call exit here.
export APP_NIMBUS_APP_TURN_SECRET="$(derive_entropy "${app_entropy_identifier}-turn-secret")"
export APP_NIMBUS_APP_TURN_REALM="nimbus"
