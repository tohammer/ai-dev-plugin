#!/bin/sh
# Structure checks for the devflow plugin. Run from anywhere: tests/run.sh
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root" || exit 1
fail=0

check() { # check <description> <command...>
    desc="$1"; shift
    if "$@" >/dev/null 2>&1; then
        echo "ok   $desc"
    else
        echo "FAIL $desc"
        fail=1
    fi
}

has_field() { # has_field <file> <field>: field present in the frontmatter
    awk -v f="$2" '
        NR == 1 && $0 != "---" { exit 1 }
        NR > 1 && $0 == "---" { exit !found }
        index($0, f ": ") == 1 { found = 1 }
        END { if (!found) exit 1 }' "$1"
}

not_has_field() { ! has_field "$@"; }

# Manifests
for f in .claude-plugin/plugin.json .claude-plugin/marketplace.json hooks/hooks.json; do
    check "$f is valid JSON" python3 -m json.tool "$f"
done

# Hook
check "hook script is executable" test -x hooks/session-start
hook_prints_core() {
    CLAUDE_PLUGIN_ROOT="$root" hooks/session-start | cmp -s - core.md
}
check "hook prints core.md" hook_prints_core
hook_fails_without_core() {
    ! CLAUDE_PLUGIN_ROOT=/nonexistent hooks/session-start
}
check "hook fails without core.md" hook_fails_without_core
core_is_short() { [ "$(wc -l < core.md)" -le 70 ]; }
check "core.md is at most 70 lines" core_is_short

# Skills
for name in init spec implement review debug wrapup audit userdocs test ship describe; do
    f="skills/$name/SKILL.md"
    check "$f exists" test -f "$f"
    check "$f has name" has_field "$f" name
    check "$f has description" has_field "$f" description
    max=100
    [ "$name" = userdocs ] && max=150 # mostly reference material, ADR 0007
    [ "$name" = audit ] && max=110 # model choices and opus criteria, ADR 0017
    [ "$name" = spec ] && max=113 # opus criteria for task marks, ADR 0017
    skill_is_short() { [ "$(wc -l < "$f")" -le "$max" ]; }
    check "$f is at most $max lines" skill_is_short
done

# Agents
for name in explorer verifier doc-checker implementer reviewer; do
    f="agents/$name.md"
    check "$f exists" test -f "$f"
    for field in name description; do
        check "$f has $field" has_field "$f" "$field"
    done
    check "$f sets no model" not_has_field "$f" model
done

# Testing rule key phrase is kept in sync, ADR 0010
for f in agents/implementer.md agents/reviewer.md skills/test/SKILL.md; do
    check "$f has the testing key phrase" \
        grep -qi 'never skip, delete or loosen a test' "$f"
done

# Model choices are written model/effort, ADR 0017. Allowed otherwise:
# "opus criteria/criterion", the "(opus: <criterion>)" task mark, and
# code spans (the host spelling map in core.md). POSIX tools only.
bare_models() { # print the file's text with the allowed forms removed
    tr '\n' ' ' < "$1" | tr -s ' ' | tr 'A-Z' 'a-z' |
        sed -e 's/`[^`]*`//g' -e 's/(opus:/(/g' -e 's/opus criteri//g' |
        sed -E 's#(haiku|sonnet|opus)/(low|medium|high|xhigh)##g'
}
no_bare_models() { # lines joined: "opus" may end a line before "criterion"
    for f in core.md skills/*/SKILL.md; do
        bare_models "$f" | grep -qE '(^|[^a-z-])(haiku|sonnet|opus)([^a-z-]|$)' &&
            return 1
    done
    return 0
}
check "core.md and skills write models as model/effort" no_bare_models
no_max_effort() {
    ! grep -niE '(haiku|sonnet|opus)/max|effort:? max([^a-z]|$)|max effort' \
        core.md skills/*/SKILL.md
}
check "no max effort" no_max_effort
no_vague_triggers() {
    ! grep -niE 'cross-module interfaces|subtle logic|correctness-critical|stronger model' \
        core.md skills/*/SKILL.md
}
check "no vague model triggers" no_vague_triggers
for name in implement test review audit; do
    f="skills/$name/SKILL.md"
    has_ladder() {
        tr '\n' ' ' < "$f" | tr -s ' ' | grep -q 'haiku/low, haiku/medium, sonnet/low, sonnet/medium, sonnet/high (about opus/low), opus/medium, opus/high, opus/xhigh'
    }
    check "$f has the full ladder" has_ladder
done

# Skills must be self-contained: a session cannot read plugin files
no_plugin_paths() { ! grep -q 'CLAUDE_PLUGIN_ROOT' skills/*/SKILL.md; }
check "skills do not reference plugin files" no_plugin_paths

# Agents named in core.md and skills exist
for a in $(grep -oh 'devflow:[a-z-]*' core.md skills/*/SKILL.md | sort -u); do
    n="${a#devflow:}"
    exists() { [ -f "agents/$n.md" ] || [ -f "skills/$n/SKILL.md" ]; }
    check "$a resolves to an agent or skill" exists
done

[ "$fail" -eq 0 ] && echo "all checks passed"
exit "$fail"
