# Exercism Helper Script

This folder contains a helper script (`exercism-helper.sh`) to simplify working with Exercism JavaScript exercises locally. It automates the most common tasks: downloading, testing, submitting, committing, and pushing.

---

## ⚙️ Installation

1. **Make the script executable**:

   ```bash
   chmod +x ~/Repositorios/exercism/tools/exercism-helper.sh
   ```

2. **Source it automatically** (so the commands are always available):

   **Ubuntu / Linux (bash)**:

   ```bash
   echo "source ~/Repositorios/exercism/tools/exercism-helper.sh" >> ~/.bashrc
   source ~/.bashrc
   ```

   **macOS (zsh)**:

   ```bash
   echo "source ~/Repositorios/exercism/tools/exercism-helper.sh" >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Verify it loaded correctly**:

   ```bash
   ex-test
   ```

   You should see a message like:

   ```
   🧠 Loaded Exercism helper on Linux using bash.
   📂 Track directory: /home/alberto/Repositorios/exercism/javascript
   ```

---

## 🧩 Commands

### 🆕 `ex-new <slug>`

Downloads and sets up a new exercise.

```bash
ex-new elyses-enchantments
```

* Downloads the exercise with the Exercism CLI.
* Switches to its folder.
* Installs dependencies automatically if missing.

---

### 🧪 `ex-test`

Runs Jest tests for the current exercise.

```bash
ex-test
```

* Automatically installs dependencies if `node_modules` is missing.
* Detects whether to use `pnpm` or `npm`.

---

### 🚀 `ex-submit`

Submits your solution to Exercism.

```bash
ex-submit
```

* Finds `.js` files (excluding test files) and submits them.

---

### 💾 `ex-commit <slug> "message"`

Commits your work from the repo root.

```bash
ex-commit elyses-enchantments "finish elyses-enchantments solution"
```

---

### 🏁 `ex-done`

Runs the full workflow.

```bash
ex-done
```

1. Runs tests.
2. Submits to Exercism if they pass.
3. Commits and pushes to GitHub.

---

### 📂 `ex-cd <slug>`

Quickly change directory to an exercise.

```bash
ex-cd lasagna
```

---

## 🧠 Example Workflow

```bash
ex-new lasagna          # Download exercise
code .                  # Open in VS Code
ex-test                 # Run tests
ex-done                 # Test + submit + commit + push
```

---

## 🧰 Troubleshooting

* If `ex-test` fails with `jest: command not found`, run `pnpm install` manually once.
* After editing the script, reload your shell:

  ```bash
  source ~/.bashrc     # Ubuntu
  source ~/.zshrc      # macOS
  ```
* The script auto-detects macOS/Linux and your shell (bash/zsh).

---

**Tip:** Keep this helper and README versioned. They turn your Exercism setup into a reproducible local environment — ready to use on any machine.
