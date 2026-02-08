import path from "path"
import react from "@vitejs/plugin-react"
import { defineConfig } from "vite"

export default defineConfig({
  plugins: [react()],
  // --- ДОБАВЛЯЕМ ЭТОТ БЛОК ---
  define: {
    'import.meta.env.VITE_EVOLUTION_API_URL': JSON.stringify(process.env.VITE_EVOLUTION_API_URL),
    'import.meta.env.VITE_EVOLUTION_API_KEY': JSON.stringify(process.env.VITE_EVOLUTION_API_KEY),
    'import.meta.env.VITE_APP_NAME': JSON.stringify(process.env.VITE_APP_NAME),
  },
  // ---------------------------
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  build: {
    outDir: "dist",
  },
})
