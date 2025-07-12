# Panel de Administración HzAnticheat

## Descripción
El Panel de Administración HzAnticheat es una interfaz web moderna e intuitiva que permite a los administradores gestionar todas las funcionalidades del anticheat desde dentro del juego.

## Características

### 🎛️ Dashboard
- **Estadísticas en tiempo real**: Visualiza jugadores conectados, total de baneos, errores detectados y estado del sistema
- **Información del sistema**: Estado del modo debug y desarrollador
- **Actualización automática**: Las estadísticas se actualizan automáticamente

### 👥 Gestión de Jugadores
- **Banear jugadores**: Banea jugadores por ID o nombre con razón personalizada
- **Duración de baneos**: Configura baneos temporales (en minutos) o permanentes
- **Validación de formularios**: Verificación automática de campos requeridos

### 🚫 Sistema de Baneos
- **Lista de baneos recientes**: Visualiza los baneos más recientes con detalles completos
- **Desbanear jugadores**: Remueve baneos usando el identificador del jugador
- **Información detallada**: Muestra razón, fecha, admin responsable y más

### ✅ Lista Blanca
- **Agregar eventos**: Permite eventos específicos en la lista blanca
- **Agregar recursos**: Permite recursos específicos en la lista blanca
- **Gestión simplificada**: Interfaz fácil de usar para modificaciones

### ⚙️ Configuración del Sistema
- **Modo Debug**: Activa/desactiva el modo debug con toggle visual
- **Modo Desarrollador**: Activa/desactiva el modo desarrollador
- **Recarga de configuración**: Recarga la configuración del anticheat
- **Controles visuales**: Switches modernos para configuraciones

### 📋 Registros del Sistema
- **Filtros de logs**: Filtra por tipo (todos, baneos, acciones admin, errores)
- **Historial completo**: Mantiene registro de todas las acciones administrativas
- **Búsqueda avanzada**: Encuentra logs específicos rápidamente

## Comandos de Acceso

### Comandos de Chat
- `/hzadmin` - Abre el panel de administración
- `/adminpanel` - Comando alternativo para abrir el panel

### Teclas de Acceso
- **F6** - Tecla por defecto para abrir el panel (configurable)
- **ESC** - Cierra el panel cuando está abierto

## Permisos

El panel utiliza el sistema de permisos existente de HzAnticheat:
- **ACE Permissions**: Verifica permisos ACE del servidor
- **txAdmin**: Integración con permisos de txAdmin
- **Lista manual**: Administradores configurados manualmente

Solo los usuarios con permisos de administrador pueden:
- Acceder al panel
- Ejecutar comandos administrativos
- Modificar configuraciones del sistema

## Características Técnicas

### Interfaz de Usuario
- **Diseño responsivo**: Se adapta a diferentes resoluciones
- **Tema moderno**: Gradientes y efectos visuales atractivos
- **Navegación intuitiva**: Sidebar con iconos y navegación clara
- **Notificaciones**: Sistema de notificaciones para feedback inmediato

### Funcionalidades Avanzadas
- **Comunicación NUI**: Comunicación bidireccional entre cliente y servidor
- **Validación de datos**: Verificación de entrada en cliente y servidor
- **Logs en tiempo real**: Sistema de logging integrado
- **Estadísticas dinámicas**: Actualización automática de datos

### Seguridad
- **Verificación de permisos**: Doble verificación en cliente y servidor
- **Validación de entrada**: Sanitización de datos de entrada
- **Logs de auditoría**: Registro de todas las acciones administrativas
- **Protección contra spam**: Limitaciones en las acciones

## Instalación

El panel se instala automáticamente con HzAnticheat. Los archivos incluidos son:

### Archivos del Cliente
- `src/client/admin_panel.lua` - Lógica del cliente
- `src/client/protections/index.html` - Interfaz web

### Archivos del Servidor
- `src/server/admin_panel_server.lua` - Lógica del servidor

### Configuración
- El panel utiliza la configuración existente de HzAnticheat
- No requiere configuración adicional
- Los permisos se gestionan a través del sistema existente

## Uso

### Abrir el Panel
1. Asegúrate de tener permisos de administrador
2. Presiona **F6** o usa `/hzadmin` en el chat
3. El panel se abrirá automáticamente

### Navegar por el Panel
1. Usa el sidebar izquierdo para cambiar entre secciones
2. Cada sección tiene funcionalidades específicas
3. Los formularios incluyen validación automática
4. Las notificaciones aparecen en la esquina superior derecha

### Cerrar el Panel
- Presiona **ESC**
- Haz clic en el botón **X** en la esquina superior derecha
- El panel se cerrará automáticamente

## Solución de Problemas

### El panel no se abre
- Verifica que tienes permisos de administrador
- Revisa la consola del servidor para errores
- Asegúrate de que HzAnticheat esté funcionando correctamente

### Comandos no funcionan
- Verifica los permisos del usuario
- Revisa los logs del servidor
- Confirma que el jugador objetivo existe (para baneos)

### Estadísticas no se actualizan
- El panel actualiza estadísticas automáticamente cada 30 segundos
- Usa el botón "Actualizar Estadísticas" para forzar una actualización
- Verifica la conexión entre cliente y servidor

## Compatibilidad

- **FiveM**: Versión 5181 o superior
- **Recursos requeridos**: screenshot-basic, HzKeepAlive
- **Navegadores**: Compatible con CEF (Chromium Embedded Framework)
- **Resoluciones**: Responsive design para todas las resoluciones

## Actualizaciones Futuras

- **Gráficos de estadísticas**: Visualización de datos en tiempo real
- **Filtros avanzados**: Más opciones de filtrado en logs y baneos
- **Exportación de datos**: Capacidad de exportar logs y estadísticas
- **Temas personalizables**: Múltiples temas de color
- **Notificaciones push**: Alertas en tiempo real para eventos importantes

## Soporte

Para soporte técnico o reportar bugs:
- Revisa los logs del servidor
- Verifica la configuración de permisos
- Contacta al equipo de desarrollo de HzAnticheat

---

**Desarrollado por HZ - CodigosParaJuegos - FiveMSoluciones**

*Panel de Administración HzAnticheat v1.0 - Gestión completa del anticheat desde dentro del juego*