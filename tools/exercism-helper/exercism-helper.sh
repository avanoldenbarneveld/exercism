#!/usr/bin/env bash
# --------------------------------------------------------
# Exercism Helper Script (cross-platform)
# Works on macOS and Linux (Ubuntu, WSL, etc.)
# --------------------------------------------------------

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  PLATFORM="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  PLATFORM="Linux"
else
  PLATFORM="Unknown"
fi

# Detect shell
SHELL_NAME=$(basename "$SHELL")

# Detect Exercism JavaScript track directory (relative to this script)
EX_JS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../javascript" && pwd)"

# Feedback
echo "🧠 Loaded Exercism helper on $PLATFORM using $SHELL_NAME."
echo "📂 Track directory: $EX_JS_DIR"

# --------------------------------------------------------
# 1) Download new exercise and set up
# --------------------------------------------------------
ex-new() {
  local slug="$1"
  if [ -z "$slug" ]; then
    echo "Usage: ex-new <exercise-slug>"
    return 1
  fi

  cd "$EX_JS_DIR" || return 1
  exercism download --track=javascript --exercise="$slug"

  cd "$EX_JS_DIR/$slug" 2>/dev/null || {
    echo "Could not cd into $EX_JS_DIR/$slug"
    return 1
  }

  # Auto-install dependencies if package.json exists
  if [ -f package.json ] && [ ! -d node_modules ]; then
    echo "📦 Installing dependencies..."
    if command -v pnpm >/dev/null 2>&1 && [ -f pnpm-lock.yaml ]; then
      pnpm install
    else
      npm install
    fi
  fi
}

# --------------------------------------------------------
# 2) Jump to an exercise
# --------------------------------------------------------
ex-cd() {
  local slug="$1"
  if [ -z "$slug" ]; then
    echo "Usage: ex-cd <exercise-slug>"
    return 1
  fi
  cd "$EX_JS_DIR/$slug" 2>/dev/null || echo "Exercise '$slug' not found."
}

# --------------------------------------------------------
# 3) Run tests (auto-installs if needed)
# --------------------------------------------------------
ex-test() {
  if [ ! -f package.json ]; then
    echo "❌ No package.json found in $(pwd)"
    return 1
  fi

  if [ ! -d node_modules ]; then
    echo "📦 Installing dependencies..."
    if command -v pnpm >/dev/null 2>&1 && [ -f pnpm-lock.yaml ]; then
      pnpm install
    else
      npm install
    fi
  fi

  echo "🧪 Running tests..."
  if command -v pnpm >/dev/null 2>&1 && [ -f pnpm-lock.yaml ]; then
    pnpm test
  else
    npm test
  fi
}

# --------------------------------------------------------
# 4) Submit current exercise
# --------------------------------------------------------
ex-submit() {
  local files
  files=$(find . -maxdepth 1 -type f -name "*.js" ! -name "*spec.js" ! -name "*test.js")
  if [ -z "$files" ]; then
    echo "❌ No implementation file found to submit."
    return 1
  fi
  echo "🚀 Submitting: $files"
  exercism submit $files
}

# --------------------------------------------------------
# 5) Commit from repo root
# --------------------------------------------------------
ex-commit() {
  local slug="$1"
  local msg="$2"
  if [ -z "$slug" ] || [ -z "$msg" ]; then
    echo "Usage: ex-commit <slug> \"commit message\""
    return 1
  fi
  cd "$EX_JS_DIR" || return 1
  git add "$slug"
  git commit -m "$msg"
}

# --------------------------------------------------------
# 6) Full workflow: test → (optional submit) → commit → push
# --------------------------------------------------------
ex-done() {
  if [ ! -f package.json ]; then
    echo "⚠️ Not inside an exercise folder."
    return 1
  fi

  local folder
  folder=$(basename "$(pwd)")

  echo "🏁 Running tests for $folder..."
  ex-test
  local test_status=$?

  if [ $test_status -ne 0 ]; then
    echo "❌ Tests failed."
    read -p "Do you still want to commit and push your current work? (y/N): " answer
    case "$answer" in
      [yY][eE][sS]|[yY])
        echo "💾 Committing incomplete solution..."
        cd .. || return 1
        git add "$folder"
        git commit -m "WIP: $folder (tests failing)"
        git push
        echo "🚀 Pushed incomplete solution for $folder."
        ;;
      *)
        echo "🛑 Aborted. Fix the tests before submitting."
        return 1
        ;;
    esac
  else
    echo "✅ Tests passed! Submitting..."
    ex-submit

    echo "🗂️ Committing and pushing..."
    cd .. || return 1
    git add "$folder"
    git commit -m "Submit $folder solution"
    git push

    echo "🎉 Done! Tests passed, submitted, committed, and pushed."
  fi
}

# --------------------------------------------------------
# Optional: detect where to source from automatically
# --------------------------------------------------------
# If running directly (not sourced), print hint
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "⚙️  To enable these commands permanently, add this line to your shell config:"
  if [ "$SHELL_NAME" = "zsh" ]; then
    echo "   source ~/Repositorios/exercism/tools/exercism-helper.sh  # macOS"
  else
    echo "   source ~/Repositorios/exercism/tools/exercism-helper.sh  # Linux"
  fi
fi
