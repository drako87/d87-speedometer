# 🏎️ D87-Speedometer

**D87-Speedometer** es una interfaz de telemetría e instrumentación vehicular flotante de diseño minimalista, alto rendimiento y calidad premium diseñada específicamente para servidores de rol en la plataforma FiveM. Ofrece una integración visual limpia y optimizada para cualquier entorno gráfico.

---

## 🌟 Características Destacadas

*   **Estética Moderna:** Interfaz flotante de alto contraste, tipografías nítidas y tacómetro secuencial con degradado azul eléctrico.
*   **Instrumentación Precisa:** Monitorización en tiempo real de combustible y durabilidad del motor con indicadores compactos.
*   **Sistema de Alertas (Blink):** Indicadores inteligentes que parpadean ante estados críticos (reserva, motor dañado, cinturón).
*   **Adaptabilidad Vehicular:** Ocultamiento automático de elementos como el cinturón al subir a motocicletas o bicicletas.

---

## 🛠️ Sistemas Inteligentes Integrados

1.  **Control de Crucero:** Limitador de velocidad nativo con desconexión pasiva al frenar.
2.  **Ópticas Interactivas:** Testigo luminoso que indica el estado de luces (apagado, cortas, largas).
3.  **Localizador de Radares:** Sistema integrado que alerta de la velocidad máxima al acercarse a zonas de control.
4.  **Mitigador de Colisiones:** Algoritmo de gestión de daños para prolongar la vida útil de los vehículos.

---

## ⚡ Ventajas Técnicas

*   **Compatibilidad:** Soporte nativo para Qbox, QBCore y ESX Legacy.
*   **Optimización:** Consumo de recursos eficiente (entre 0.01 ms y 0.02 ms).
*   **Independencia:** Sistema autónomo, sin dependencias externas o librerías web.
*   **Integración:** Compatible con los principales sistemas de combustible (`ox_fuel`, `LegacyFuel`, etc.).

---

## ⚙️ Configuración (`config.lua`)

El recurso cuenta con un archivo de configuración centralizado para ajustar comportamientos, unidades (KM/H o MPH), posiciones y compatibilidad de frameworks.

```lua
Config = {}
Config.Framework = 'auto'          -- Detecta: 'qbox', 'qb-core', 'esx'
Config.Size = 1.0                  -- Escala del HUD
Config.UseMPH = false              -- Unidad de velocidad
Config.VehicleDamageMultiplier = 0.3 -- Resistencia mecánica
Config.EnableRadars = true         -- Activar radares
Config.FuelSystem = 'auto'         -- Sistema de gasolina
```

---

## 📥 Instalación

1.  Coloca la carpeta `d87-speedometer` en tus recursos.
2.  Añade `ensure d87-speedometer` a tu `server.cfg`.

---

## 👤 Autoría
*   **Autor:** `Drako87/Dracatt`
*   **Recurso:** D87-Speedometer
