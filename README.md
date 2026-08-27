# Tauri-vite-build-config-templates
Tauri vite build config templates files with all commands and batch commands with detail. just double click bat

#### double click verify.bat in the project folder to check all depend and req for Tauri
#### dev.bat for batch all commands nec , just run as admin and enjoy while sitting

A clean, modern boilerplate for building cross-platform desktop applications using Tauri v2, Rust, and web technologies.

## 📁 Project Structure

```text
my-tauri-app/
├── Cargo.toml          # Rust dependencies & package configuration
├── build.rs            # Tauri build script
├── src/
│   └── main.rs         # Rust backend entry point & command handlers
└── tauri.conf.json     # Tauri window & application configuration
```

---

## ⚙️ Prerequisites

Before running or building the application, ensure you have the following installed:
1. **Node.js** (LTS recommended) along with a package manager (`npm`, `pnpm`, or `yarn`).
2. **Rust toolchain** (`rustc` and `cargo`). Install via [rustup.rs](https://rustup.rs/).
3. **Platform-specific dependencies**:
   - **Windows**: Microsoft C++ Build Tools & WebView2.
   - **macOS**: Xcode Command Line Tools (`xcode-select --install`).
   - **Linux**: WebKitGTK and base build essentials (`libwebkit2gtk-4.0-dev`, `build-essential`, etc.).

---

## 🚀 Quick Start Commands

### 1. Install Frontend Dependencies
```bash
npm install
```

### 2. Run in Development Mode
Starts the frontend dev server and launches the desktop app with hot-reloading:
```bash
npm run tauri dev
```

### 3. Build for Production
Compiles the frontend assets and packages a standalone production binary/installer for your operating system:
```bash
npm run tauri build
```

---

## 🛠️ Adding Custom Rust Commands

To expose backend functionality to your frontend JavaScript/TypeScript code:

1. Define a command inside `src/main.rs`:
   ```rust
   #[tauri::command]
   fn my_custom_command() -> String {
       "Hello from Rust backend!".into()
   }
   ```

2. Register the command in the Tauri builder inside `main.rs`:
   ```rust
   fn main() {
       tauri::Builder::default()
           .invoke_handler(tauri::generate_handler![greet, my_custom_command])
           .run(tauri::generate_context!())
           .expect("error while running tauri application");
   }
   ```

3. Call the command from your frontend code:
   ```javascript
   import { invoke } from '@tauri-apps/api/core';

   async function callBackend() {
       const response = await invoke('my_custom_command');
       console.log(response);
   }
   ```
4. Run bat file as admin and rest of all will be done by bat . 


farrukh Barlas 
