# Exercism Helper Script

This folder contains the helper script (`exercism-helper.sh`) that extends the official Exercism CLI with automation for JavaScript exercises. It streamlines the workflow by handling downloads, installations, testing, submissions, commits, and pushes — all with simple commands.

---

## ⚙️ Installation

1. **Make the script executable:**

   ```bash
   chmod +x ~/Repositorios/exercism/tools/exercism-helper.sh
   ```

2. **Source it automatically** so the commands are always available:

   **Ubuntu / Linux (bash):**

   ```bash
   echo "source ~/exercism/tools/exercism-helper.sh" >> ~/.bashrc
   source ~/.bashrc
   ```

   **macOS (zsh):**

   ```bash
   echo "source ~/Repositorios/exercism/tools/exercism-helper.sh" >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Verify it loaded correctly:**

   ```bash
   ex-test
   ```

   You should see something like:

   ```
   🧠 Loaded Exercism helper on Linux using bash.
   📂 Track directory: /home/alberto/Repositorios/exercism/javascript
   ```

---

## 🧩 Commands Overview

### 🆕 `ex-new <slug>`

Downloads and sets up a new exercise.

```bash
ex-new elyses-enchantments
```

* Downloads the exercise using the Exercism CLI.
* Moves into its folder.
* Installs dependencies automatically if needed.

---

### 🧪 `ex-test`

Runs Jest tests for the current exercise.

```bash
ex-test
```

* Automatically installs dependencies if missing.
* Detects whether to use `pnpm` or `npm`.

---

### 🚀 `ex-submit`

Submits your implementation files to Exercism.

```bash
ex-submit
```

* Finds `.js` files (excluding test files) and submits them.
* Prints the submission URL.

---

### 💾 `ex-commit <slug> "message"`

Commits your progress from the repo root.

```bash
ex-commit elyses-enchantments "finish elyses-enchantments exercise"
```

---

### 🏁 `ex-done`

Runs the full workflow.

```bash
ex-done
```

1. Runs tests.
2. If they pass → submits, commits, and pushes.
3. If they fail → prompts whether to commit a WIP version anyway.

Example prompt when tests fail:

```
❌ Tests failed.
Do you still want to commit and push your current work? (y/N):
```

If you confirm with `y`, it will commit and push with a message like:

```
WIP: elyses-enchantments (tests failing)
```

---

### 📂 `ex-cd <slug>`

Quickly navigate to an exercise folder.

```bash
ex-cd lasagna
```

---

## 🧠 Example Workflow

```bash
ex-new lasagna          # Download new exercise
code .                  # Open in VS Code
ex-test                 # Run tests
ex-done                 # Test + submit + commit + push
```

---

## 🧰 Troubleshooting

* If `jest` is missing, run `pnpm install` manually once.
* After editing the script, reload your shell:

  ```bash
  source ~/.bashrc     # Ubuntu
  source ~/.zshrc      # macOS
  ```
* The script auto-detects macOS/Linux and bash/zsh shells.
* To silence the startup message when opening new terminals, wrap the `echo` lines with:

  ```bash
  if [[ $- == *i* ]]; then
    echo "🧠 Loaded Exercism helper..."
  fi
  ```

---

### 💡 Tip

Keep this helper and README versioned. It turns your Exercism setup into a reproducible local environment you can clone and reuse on any machine.
