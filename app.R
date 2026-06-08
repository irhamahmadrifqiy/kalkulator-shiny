# ============================================================
# KALKULATOR INTERAKTIF MODERN - R Shiny
# Sistem Informasi Manajemen
# ============================================================

library(shiny)
library(bslib)
library(DT)
library(plotly)
library(shinyWidgets)
library(shinycssloaders)

# ─── CSS (dark + light variables) ───────────────────────────
custom_css <- "
@import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;600&display=swap');

/* ══════════════════════════════
   THEME VARIABLES
══════════════════════════════ */
:root {
  --accent:        #6C63FF;
  --accent2:       #FF6584;
  --accent3:       #43E97B;
  --radius:        16px;
  --shadow:        0 8px 32px rgba(0,0,0,0.18);
  --transition:    all 0.35s cubic-bezier(0.4,0,0.2,1);
}

/* ── DARK MODE (default) ── */
body.mode-dark {
  --bg:            #0d0d1a;
  --bg-sidebar:    rgba(14,14,28,0.97);
  --bg-card:       rgba(255,255,255,0.06);
  --bg-card-hover: rgba(255,255,255,0.10);
  --border:        rgba(255,255,255,0.10);
  --border-focus:  rgba(108,99,255,0.50);
  --text:          #e8e8f5;
  --text-muted:    rgba(232,232,245,0.45);
  --input-color:   #ffffff;
  --sidebar-line:  rgba(108,99,255,0.20);
  --tab-active-bg: rgba(108,99,255,0.20);
  --tab-active-border: rgba(108,99,255,0.45);
  --tab-color:     rgba(255,255,255,0.45);
  --tab-active-color: #ffffff;
  --plot-txt:      rgba(255,255,255,0.65);
  --plot-grid:     rgba(255,255,255,0.07);
  --dt-head:       rgba(108,99,255,0.15);
  --dt-head-color: rgba(255,255,255,0.7);
  --dt-head-line:  rgba(108,99,255,0.3);
  --dt-row-hover:  rgba(108,99,255,0.08);
  --dt-border:     rgba(255,255,255,0.06);
  --dt-text:       rgba(255,255,255,0.75);
  --logo-sub:      rgba(255,255,255,0.35);
  --footer-color:  rgba(255,255,255,0.22);
  --mesh1: rgba(108,99,255,0.22);
  --mesh2: rgba(255,101,132,0.14);
  --mesh3: rgba(67,233,123,0.07);
  --result-text:   #ffffff;
  --sentence-color: rgba(232,232,245,0.88);
  --empty-color:   rgba(255,255,255,0.28);
}

/* ── LIGHT MODE ── */
body.mode-light {
  --bg:            #f4f4fb;
  --bg-sidebar:    #ffffff;
  --bg-card:       rgba(108,99,255,0.05);
  --bg-card-hover: rgba(108,99,255,0.10);
  --border:        rgba(108,99,255,0.15);
  --border-focus:  rgba(108,99,255,0.55);
  --text:          #1a1a2e;
  --text-muted:    rgba(26,26,46,0.50);
  --input-color:   #1a1a2e;
  --sidebar-line:  rgba(108,99,255,0.15);
  --tab-active-bg: rgba(108,99,255,0.12);
  --tab-active-border: rgba(108,99,255,0.40);
  --tab-color:     rgba(26,26,46,0.50);
  --tab-active-color: #1a1a2e;
  --plot-txt:      rgba(26,26,46,0.70);
  --plot-grid:     rgba(26,26,46,0.08);
  --dt-head:       rgba(108,99,255,0.08);
  --dt-head-color: rgba(26,26,46,0.75);
  --dt-head-line:  rgba(108,99,255,0.20);
  --dt-row-hover:  rgba(108,99,255,0.06);
  --dt-border:     rgba(26,26,46,0.07);
  --dt-text:       rgba(26,26,46,0.80);
  --logo-sub:      rgba(26,26,46,0.40);
  --footer-color:  rgba(26,26,46,0.30);
  --mesh1: rgba(108,99,255,0.10);
  --mesh2: rgba(255,101,132,0.07);
  --mesh3: rgba(67,233,123,0.05);
  --result-text:   #1a1a2e;
  --sentence-color: rgba(26,26,46,0.85);
  --empty-color:   rgba(26,26,46,0.30);
}

/* ══════════════════════════════
   BASE
══════════════════════════════ */
* { box-sizing: border-box; margin: 0; padding: 0; }

body {
  font-family: 'Plus Jakarta Sans', sans-serif !important;
  background: var(--bg) !important;
  color: var(--text) !important;
  min-height: 100vh;
  transition: background 0.4s ease, color 0.4s ease;
}

body::before {
  content: '';
  position: fixed; inset: 0; z-index: -1;
  background:
    radial-gradient(ellipse 80% 60% at 15% 10%, var(--mesh1) 0%, transparent 60%),
    radial-gradient(ellipse 55% 50% at 85% 80%, var(--mesh2) 0%, transparent 55%),
    radial-gradient(ellipse 45% 40% at 50% 45%, var(--mesh3) 0%, transparent 55%),
    var(--bg);
  transition: background 0.4s ease;
}

/* ══════════════════════════════
   LAYOUT
══════════════════════════════ */
.main-wrapper { display: flex; min-height: 100vh; }

/* ── Sidebar ── */
.sidebar-panel {
  width: 290px; min-width: 260px;
  background: var(--bg-sidebar);
  border-right: 1px solid var(--sidebar-line);
  padding: 26px 20px;
  display: flex; flex-direction: column; gap: 18px;
  position: sticky; top: 0; height: 100vh; overflow-y: auto;
  transition: background 0.4s ease, border-color 0.4s ease;
  box-shadow: 2px 0 20px rgba(0,0,0,0.06);
}

/* ── Logo ── */
.app-logo { text-align: center; padding-bottom: 14px; border-bottom: 1px solid var(--border); }
.app-logo h1 {
  font-size: 1.45rem; font-weight: 800;
  background: linear-gradient(135deg, #6C63FF, #FF6584);
  -webkit-background-clip: text; -webkit-text-fill-color: transparent;
  letter-spacing: -0.5px;
}
.app-logo p {
  font-size: 0.68rem; color: var(--logo-sub); margin-top: 4px;
  text-transform: uppercase; letter-spacing: 1.8px;
}

/* ── Section label ── */
.sec-heading {
  font-size: 0.67rem; text-transform: uppercase; letter-spacing: 1.6px;
  color: var(--text-muted); margin-bottom: 8px; font-weight: 600;
}

/* ── Input cards ── */
.input-section { display: flex; flex-direction: column; gap: 12px; }
.input-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius); padding: 13px 15px;
  transition: var(--transition);
}
.input-card:focus-within {
  border-color: var(--border-focus);
  box-shadow: 0 0 0 3px rgba(108,99,255,0.14);
}
.input-card label {
  font-size: 0.68rem; font-weight: 700; text-transform: uppercase;
  letter-spacing: 1.3px; color: var(--text-muted); margin-bottom: 5px; display: block;
}
.input-card .form-control {
  background: transparent !important; border: none !important; outline: none !important;
  color: var(--input-color) !important; font-size: 1.35rem !important;
  font-family: 'JetBrains Mono', monospace !important; font-weight: 600 !important;
  padding: 0 !important; box-shadow: none !important; width: 100% !important;
}

/* ── Hitung button ── */
.btn-hitung {
  background: linear-gradient(135deg, #6C63FF, #9b59b6) !important;
  border: none !important; border-radius: var(--radius) !important;
  color: #fff !important; font-family: 'Plus Jakarta Sans', sans-serif !important;
  font-size: 1rem !important; font-weight: 800 !important; letter-spacing: 0.3px;
  padding: 13px 20px !important; width: 100% !important; cursor: pointer !important;
  transition: var(--transition) !important;
  box-shadow: 0 4px 22px rgba(108,99,255,0.42) !important;
  position: relative; overflow: hidden;
}
.btn-hitung:hover {
  transform: translateY(-2px) !important;
  box-shadow: 0 8px 30px rgba(108,99,255,0.58) !important;
}
.btn-hitung:active { transform: translateY(0) !important; }
.btn-hitung.pulse { animation: btnPulse 0.45s ease; }
@keyframes btnPulse {
  0%   { transform: scale(1); }
  40%  { transform: scale(1.055); }
  100% { transform: scale(1); }
}

/* ── Dark Mode Toggle ── */
.darkmode-wrap {
  display: flex; align-items: center; gap: 10px;
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: 99px; padding: 6px 14px 6px 10px;
  cursor: pointer; transition: var(--transition);
}
.darkmode-wrap:hover { border-color: var(--border-focus); }
.darkmode-label { font-size: 0.8rem; font-weight: 600; color: var(--text-muted); flex: 1; }
/* toggle switch */
.toggle-track {
  width: 40px; height: 22px; border-radius: 11px;
  background: #6C63FF; position: relative; transition: background 0.3s;
  flex-shrink: 0;
}
body.mode-light .toggle-track { background: #ccc; }
.toggle-thumb {
  position: absolute; top: 3px; left: 3px;
  width: 16px; height: 16px; border-radius: 50%; background: #fff;
  transition: transform 0.3s cubic-bezier(0.4,0,0.2,1);
  box-shadow: 0 1px 4px rgba(0,0,0,0.2);
}
body.mode-dark .toggle-thumb { transform: translateX(18px); }
body.mode-light .toggle-thumb { transform: translateX(0); }

/* ── Clear button ── */
.btn-clear-hist {
  background: rgba(255,101,132,0.09);
  border: 1px solid rgba(255,101,132,0.28);
  border-radius: var(--radius); color: #FF6584;
  font-family: 'Plus Jakarta Sans', sans-serif;
  font-size: 0.83rem; font-weight: 700;
  padding: 10px; width: 100%; cursor: pointer; transition: var(--transition);
}
.btn-clear-hist:hover { background: rgba(255,101,132,0.20); }

/* ══════════════════════════════
   MAIN AREA
══════════════════════════════ */
.main-area { flex: 1; padding: 30px 34px; overflow-y: auto; }

/* ── Badge ── */
.badge-complete {
  display: inline-flex; align-items: center; gap: 7px;
  background: rgba(67,233,123,0.10);
  border: 1px solid rgba(67,233,123,0.28);
  border-radius: 99px; padding: 4px 14px;
  font-size: 0.7rem; font-weight: 700; color: #43E97B;
  letter-spacing: 0.6px; margin-bottom: 18px;
}
.badge-dot { width: 6px; height: 6px; border-radius: 50%; background: #43E97B; animation: blink 1.2s infinite; }
@keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.25} }

/* ── Tab nav ── */
.nav-tabs {
  border-bottom: 1px solid var(--border) !important;
  gap: 3px; margin-bottom: 26px !important;
}
.nav-tabs .nav-link {
  background: transparent !important; border: 1px solid transparent !important;
  color: var(--tab-color) !important;
  border-radius: 10px 10px 0 0 !important;
  font-size: 0.83rem; font-weight: 600;
  padding: 9px 16px !important; transition: var(--transition) !important;
}
.nav-tabs .nav-link:hover { color: var(--text) !important; background: var(--bg-card) !important; }
.nav-tabs .nav-link.active {
  color: var(--tab-active-color) !important;
  background: var(--tab-active-bg) !important;
  border-color: var(--tab-active-border) !important;
  border-bottom-color: transparent !important;
}

/* ══════════════════════════════
   RESULT SENTENCE STYLE
   Format: 'Penjumlahan ... yaitu **HASIL**'
══════════════════════════════ */

.result-sentence-wrap {
  display: flex; flex-direction: column; gap: 12px;
  margin-bottom: 28px; animation: fadeInUp 0.35s ease both;
}
.result-sentence {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius); padding: 16px 20px;
  font-size: 1rem; color: var(--sentence-color); line-height: 1.5;
  transition: var(--transition), background 0.4s, border-color 0.4s;
  border-left: 4px solid transparent;
  animation: fadeInUp 0.4s ease both;
}
.result-sentence:hover { background: var(--bg-card-hover); transform: translateX(3px); }
.result-sentence:nth-child(1) { border-left-color: #43E97B;  animation-delay: 0.05s; }
.result-sentence:nth-child(2) { border-left-color: #ffd200;  animation-delay: 0.10s; }
.result-sentence:nth-child(3) { border-left-color: #6C63FF;  animation-delay: 0.15s; }
.result-sentence:nth-child(4) { border-left-color: #FF6584;  animation-delay: 0.20s; }
.result-sentence:nth-child(5) { border-left-color: #4facfe;  animation-delay: 0.25s; }

.result-sentence .bold-val {
  font-family: 'JetBrains Mono', monospace;
  font-weight: 700; font-size: 1.08rem;
  color: var(--result-text);
}

/* single-tab big card */
.single-op-big {
  max-width: 480px; margin: 0 auto; text-align: center;
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: 24px; padding: 44px 40px;
  animation: fadeInUp 0.4s ease;
  transition: background 0.4s, border-color 0.4s;
}
.single-op-big .op-icon-big { font-size: 3.2rem; }
.single-op-big .op-title {
  font-size: 0.75rem; text-transform: uppercase; letter-spacing: 2px;
  color: var(--text-muted); margin-top: 12px;
}
.single-op-big .op-sentence {
  font-size: 1.1rem; color: var(--sentence-color);
  margin-top: 18px; line-height: 1.6;
}
.single-op-big .bold-val {
  font-family: 'JetBrains Mono', monospace; font-weight: 700; font-size: 1.2rem;
  color: var(--result-text);
}
/* counter animation number */
.single-op-big .op-number {
  font-family: 'JetBrains Mono', monospace; font-weight: 800; font-size: 2.8rem;
  color: var(--accent); margin-top: 8px; animation: countUp 0.6s ease both;
}
@keyframes countUp {
  from { opacity:0; transform: scale(0.7) translateY(10px); }
  to   { opacity:1; transform: scale(1) translateY(0); }
}
.single-op-big .op-formula {
  font-family: 'JetBrains Mono', monospace; font-size: 0.82rem;
  color: var(--text-muted); margin-top: 10px;
}

/* ══════════════════════════════
   ALERT ERROR
══════════════════════════════ */
.alert-error {
  background: rgba(255,101,132,0.10);
  border: 1px solid rgba(255,101,132,0.30);
  border-left: 4px solid #FF6584;
  border-radius: var(--radius); padding: 13px 18px;
  color: #FF6584; font-size: 0.9rem; font-weight: 600;
  animation: shake 0.35s ease;
}
@keyframes shake { 0%,100%{transform:translateX(0)} 25%{transform:translateX(-7px)} 75%{transform:translateX(7px)} }

/* ══════════════════════════════
   PLOT WRAP
══════════════════════════════ */
.plot-wrap {
  background: var(--bg-card); border: 1px solid var(--border);
  border-radius: var(--radius); padding: 18px; margin-top: 6px;
  transition: background 0.4s, border-color 0.4s;
}

/* ══════════════════════════════
   DATATABLES
══════════════════════════════ */
.dataTables_wrapper { color: var(--dt-text) !important; }
table.dataTable thead th {
  background: var(--dt-head) !important; color: var(--dt-head-color) !important;
  border-bottom: 1px solid var(--dt-head-line) !important; font-size: 0.78rem;
}
table.dataTable tbody tr { background: transparent !important; }
table.dataTable tbody tr:hover { background: var(--dt-row-hover) !important; }
table.dataTable tbody td { border-color: var(--dt-border) !important; font-size: 0.83rem; }
.dataTables_info,.dataTables_filter label,.dataTables_length label { color: var(--text-muted) !important; font-size: 0.78rem; }
.dataTables_paginate .paginate_button { color: var(--text-muted) !important; }
.dataTables_paginate .paginate_button.current {
  background: var(--tab-active-bg) !important; color: var(--text) !important;
  border-radius: 6px !important;
}

/* ── Footer ── */
.app-footer {
  text-align: center; padding: 16px; margin-top: 28px;
  border-top: 1px solid var(--border);
  font-size: 0.73rem; color: var(--footer-color); letter-spacing: 0.4px;
  transition: border-color 0.4s, color 0.4s;
}

/* ── Animations ── */
@keyframes fadeInUp {
  from { opacity:0; transform:translateY(18px); }
  to   { opacity:1; transform:translateY(0); }
}

/* ── Scrollbar ── */
::-webkit-scrollbar { width: 5px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb { background: rgba(108,99,255,0.3); border-radius: 9px; }

/* ── empty state ── */
.empty-state {
  text-align: center; padding: 60px 20px;
  color: var(--empty-color); font-size: 0.93rem; line-height: 1.7;
}
.empty-state .es-icon { font-size: 2.4rem; margin-bottom: 10px; opacity: 0.4; }
"

# ─── JavaScript ──────────────────────────────────────────────
custom_js <- "
$(document).ready(function(){

  // Default: dark mode
  $('body').addClass('mode-dark');

  // Dark / Light toggle
  $(document).on('click', '#darkmode_toggle', function(){
    if($('body').hasClass('mode-dark')){
      $('body').removeClass('mode-dark').addClass('mode-light');
      $('#toggle_label').text('Light Mode');
    } else {
      $('body').removeClass('mode-light').addClass('mode-dark');
      $('#toggle_label').text('Dark Mode');
    }
  });

  // Pulse on submit
  $(document).on('click', '#hitung_btn', function(){
    $(this).addClass('pulse');
    setTimeout(()=>$(this).removeClass('pulse'), 500);
  });

  // Toast
  Shiny.addCustomMessageHandler('show_toast', function(msg){
    var toast = $('<div>').css({
      position:'fixed', bottom:'26px', right:'26px', zIndex:9999,
      background:'rgba(20,20,40,0.96)',
      border:'1px solid rgba(108,99,255,0.45)',
      borderRadius:'14px', padding:'13px 22px',
      color:'#fff', fontFamily:\"'Plus Jakarta Sans',sans-serif\",
      fontSize:'0.88rem', fontWeight:'600',
      boxShadow:'0 8px 30px rgba(0,0,0,0.35)',
      display:'flex', alignItems:'center', gap:'10px',
      opacity:0, transform:'translateY(18px)',
      transition:'all 0.32s cubic-bezier(0.4,0,0.2,1)'
    }).html('<span style=\"color:#43E97B;font-size:1.15rem\">&#10003;</span>' + msg);
    $('body').append(toast);
    setTimeout(()=>toast.css({opacity:1,transform:'translateY(0)'}),10);
    setTimeout(()=>{toast.css({opacity:0,transform:'translateY(18px)'});setTimeout(()=>toast.remove(),380);},3000);
  });

  // Counter animation for single-tab number
  Shiny.addCustomMessageHandler('counter_anim', function(data){
    var el = document.getElementById(data.id);
    if(!el) return;
    var start = 0, end = data.value, duration = 600;
    var startTime = null;
    function step(ts){
      if(!startTime) startTime = ts;
      var p = Math.min((ts - startTime)/duration, 1);
      var ease = 1 - Math.pow(1 - p, 3);
      var cur = start + (end - start)*ease;
      el.textContent = Number.isInteger(end) ? Math.round(cur) : parseFloat(cur.toFixed(4));
      if(p < 1) requestAnimationFrame(step);
      else el.textContent = data.display;
    }
    requestAnimationFrame(step);
  });
});
"

# ─── Helpers ────────────────────────────────────────────────
fmt <- function(x) {
  if (is.na(x) || is.null(x)) return("—")
  if (abs(x) >= 1e8 || (abs(x) < 1e-5 && x != 0))
    return(formatC(x, format="e", digits=4))
  # nice number
  if (x == round(x)) return(format(x, big.mark=",", scientific=FALSE))
  formatC(x, format="f", digits=4, drop0trailing=TRUE)
}

error_box <- function(msg) div(class="alert-error", "⚠ ", msg)

# Sentence card: "Penjumlahan kedua bilangan tersebut yaitu **HASIL**"
sentence_card <- function(kalimat, bold_val) {
  tags$div(class="result-sentence",
           kalimat, " ",
           tags$strong(class="bold-val", bold_val)
  )
}

# ─── UI ──────────────────────────────────────────────────────
ui <- fluidPage(
  theme = bs_theme(version=5),
  tags$head(
    tags$style(HTML(custom_css)),
    tags$script(HTML(custom_js)),
    tags$title("Kalkulator Interaktif")
  ),
  
  div(class="main-wrapper",
      
      # ═══════════════════════════════
      # SIDEBAR
      # ═══════════════════════════════
      div(class="sidebar-panel",
          
          div(class="app-logo",
              tags$h1("∑ Kalkulator"),
              tags$p("Sistem Informasi Manajemen")
          ),
          
          # Inputs
          div(class="input-section",
              div(class="sec-heading", "Input Bilangan"),
              div(class="input-card",
                  tags$label("Bilangan Pertama"),
                  numericInput("num1", NULL, value=NULL, width="100%")
              ),
              div(class="input-card",
                  tags$label("Bilangan Kedua"),
                  numericInput("num2", NULL, value=NULL, width="100%")
              )
          ),
          
          # Submit button (actionButton styled)
          actionButton("hitung_btn", "⚡  Hitung", class="btn-hitung"),
          
          # Dark Mode Toggle
          div(class="sec-heading", "Tampilan"),
          div(class="darkmode-wrap", id="darkmode_toggle",
              div(class="toggle-track", div(class="toggle-thumb")),
              span(id="toggle_label", class="darkmode-label", "Dark Mode")
          ),
          
          # Clear history
          tags$button("🗑  Hapus Riwayat", id="clear_hist_btn", class="btn-clear-hist",
                      onclick="Shiny.setInputValue('clear_hist_btn', Math.random())"
          ),
          
          div(class="app-footer",
              "Aplikasi Kalkulator Interaktif R Shiny", tags$br(),
              "Sistem Informasi Manajemen"
          )
      ),
      
      # ═══════════════════════════════
      # MAIN AREA
      # ═══════════════════════════════
      div(class="main-area",
          
          uiOutput("badge_ui"),
          
          tabsetPanel(id="main_tabs",
                      
                      # ── Tab 1: Semua Operasi ──
                      tabPanel("Semua Operasi",
                               br(),
                               uiOutput("all_ops_ui"),
                               div(class="plot-wrap",
                                   withSpinner(plotlyOutput("main_plot", height="300px"), type=6, color="#6C63FF")
                               )
                      ),
                      
                      # ── Tab 2: Penjumlahan ──
                      tabPanel("Penjumlahan",   br(), uiOutput("tab_plus_ui")),
                      
                      # ── Tab 3: Pengurangan ──
                      tabPanel("Pengurangan",   br(), uiOutput("tab_minus_ui")),
                      
                      # ── Tab 4: Perkalian ──
                      tabPanel("Perkalian",     br(), uiOutput("tab_times_ui")),
                      
                      # ── Tab 5: Pembagian ──
                      tabPanel("Pembagian",     br(), uiOutput("tab_div_ui")),
                      
                      # ── Tab 6: Pangkat ──
                      tabPanel("Pangkat",       br(), uiOutput("tab_pow_ui")),
                      
                      # ── Tab 7: Riwayat ──
                      tabPanel("Riwayat",
                               br(),
                               withSpinner(DTOutput("history_tbl"), type=6, color="#6C63FF")
                      )
          )
      )
  )
)

# ─── SERVER ──────────────────────────────────────────────────
server <- function(input, output, session) {
  
  rv <- reactiveValues(
    triggered = FALSE,
    n1 = 0, n2 = 0,
    calc_count = 0,
    history = data.frame(
      Waktu=character(), `Bilangan 1`=numeric(), `Bilangan 2`=numeric(),
      Penjumlahan=character(), Pengurangan=character(),
      Perkalian=character(), Pembagian=character(), Pangkat=character(),
      check.names=FALSE, stringsAsFactors=FALSE
    )
  )
  
  # ── Tombol Hitung ──────────────────────────────────────────
  observeEvent(input$hitung_btn, {
    n1 <- input$num1; n2 <- input$num2
    if (is.na(n1) || is.null(n1) || is.na(n2) || is.null(n2)) {
      session$sendCustomMessage("show_toast", "⚠ Input tidak boleh kosong!")
      return()
    }
    rv$n1 <- n1; rv$n2 <- n2; rv$triggered <- TRUE; rv$calc_count <- rv$calc_count + 1
    
    div_val <- if (n2 == 0) NA else n1 / n2
    pow_val <- tryCatch(n1 ^ n2, error = function(e) NA)
    
    # Tambah riwayat
    rv$history <- rbind(
      data.frame(
        Waktu         = format(Sys.time(), "%H:%M:%S"),
        `Bilangan 1`  = n1,
        `Bilangan 2`  = n2,
        Penjumlahan   = fmt(n1 + n2),
        Pengurangan   = fmt(n1 - n2),
        Perkalian     = fmt(n1 * n2),
        Pembagian     = if (is.na(div_val)) "Tidak terdefinisi" else fmt(div_val),
        Pangkat       = if (is.na(pow_val)) "Error" else fmt(pow_val),
        check.names=FALSE, stringsAsFactors=FALSE
      ),
      rv$history
    )
    session$sendCustomMessage("show_toast", paste0("Kalkulasi #", rv$calc_count, " berhasil!"))
  })
  
  # ── Hapus Riwayat ──────────────────────────────────────────
  observeEvent(input$clear_hist_btn, {
    rv$history <- rv$history[0,]
    rv$calc_count <- 0
    session$sendCustomMessage("show_toast", "Riwayat berhasil dihapus.")
  })
  
  # ── Computed ───────────────────────────────────────────────
  vals <- reactive({
    req(rv$triggered)
    n1 <- rv$n1; n2 <- rv$n2
    list(
      n1    = n1, n2 = n2,
      plus  = n1 + n2,
      minus = n1 - n2,
      times = n1 * n2,
      div   = if (n2 == 0) NA else n1 / n2,
      pow   = tryCatch(n1 ^ n2, error = function(e) NA)
    )
  })
  
  # ── Badge ──────────────────────────────────────────────────
  output$badge_ui <- renderUI({
    if (!rv$triggered) return(NULL)
    div(class="badge-complete", div(class="badge-dot"), "Calculation Complete")
  })
  
  # ── All Ops ────────────────────────────────────────────────
  output$all_ops_ui <- renderUI({
    if (!rv$triggered)
      return(div(class="empty-state", div(class="es-icon","🧮"),
                 "Masukkan dua bilangan dan tekan", tags$strong("⚡ Hitung")))
    v <- vals()
    div(
      div(class="sec-heading", "Hasil Operasi"),
      div(class="result-sentence-wrap",
          sentence_card(
            paste0("Penjumlahan kedua bilangan tersebut yaitu"),
            fmt(v$plus)
          ),
          sentence_card(
            paste0("Pengurangan kedua bilangan tersebut yaitu"),
            fmt(v$minus)
          ),
          sentence_card(
            paste0("Perkalian kedua bilangan tersebut yaitu"),
            fmt(v$times)
          ),
          if (is.na(v$div))
            error_box("Pembagian kedua bilangan tersebut: Tidak dapat membagi dengan nol.")
          else
            sentence_card(
              paste0("Pembagian kedua bilangan tersebut yaitu"),
              fmt(v$div)
            ),
          if (is.na(v$pow))
            error_box("Pangkat tidak dapat dihitung.")
          else
            sentence_card(
              paste0("Pangkat kedua bilangan tersebut (", v$n1, " ^ ", v$n2, ") yaitu"),
              fmt(v$pow)
            )
      )
    )
  })
  
  # ── Single Tab helper ──────────────────────────────────────
  make_single_tab <- function(icon, label, kalimat_fn, get_val, counter_id) {
    renderUI({
      if (!rv$triggered)
        return(div(class="empty-state", div(class="es-icon", icon),
                   "Tekan", tags$strong("⚡ Hitung"), "terlebih dahulu"))
      v   <- vals()
      val <- get_val(v)
      if (!is.na(val)) {
        # trigger counter animation via JS
        session$sendCustomMessage("counter_anim",
                                  list(id=counter_id, value=as.numeric(val), display=fmt(val)))
      }
      if (is.na(val)) {
        error_box("Tidak dapat membagi dengan nol.")
      } else {
        div(class="single-op-big",
            div(class="op-icon-big", icon),
            div(class="op-title", label),
            div(class="op-number", id=counter_id, fmt(val)),
            div(class="op-sentence",
                kalimat_fn(v), " ",
                tags$strong(class="bold-val", fmt(val))
            ),
            div(class="op-formula",
                paste0(v$n1, " ", switch(label,
                                         "Penjumlahan"="+","Pengurangan"="-","Perkalian"="×",
                                         "Pembagian"="÷","Pangkat"="^"), " ", v$n2, " = ", fmt(val))
            )
        )
      }
    })
  }
  
  output$tab_plus_ui  <- make_single_tab("➕","Penjumlahan",
                                         function(v) paste0("Penjumlahan kedua bilangan tersebut yaitu"),
                                         function(v) v$plus, "cnt_plus")
  
  output$tab_minus_ui <- make_single_tab("➖","Pengurangan",
                                         function(v) paste0("Pengurangan kedua bilangan tersebut yaitu"),
                                         function(v) v$minus, "cnt_minus")
  
  output$tab_times_ui <- make_single_tab("✖","Perkalian",
                                         function(v) paste0("Perkalian kedua bilangan tersebut yaitu"),
                                         function(v) v$times, "cnt_times")
  
  output$tab_div_ui   <- make_single_tab("➗","Pembagian",
                                         function(v) paste0("Pembagian kedua bilangan tersebut yaitu"),
                                         function(v) v$div, "cnt_div")
  
  output$tab_pow_ui   <- make_single_tab("🔺","Pangkat",
                                         function(v) paste0("Pangkat kedua bilangan (", v$n1, "^", v$n2, ") tersebut yaitu"),
                                         function(v) v$pow, "cnt_pow")
  
  # ── Plotly ─────────────────────────────────────────────────
  output$main_plot <- renderPlotly({
    empty_plot <- function(msg) {
      plot_ly() %>%
        layout(
          plot_bgcolor="rgba(0,0,0,0)", paper_bgcolor="rgba(0,0,0,0)",
          xaxis=list(visible=FALSE), yaxis=list(visible=FALSE),
          annotations=list(list(
            text=msg, showarrow=FALSE,
            font=list(color="rgba(150,150,180,0.6)", size=13,
                      family="'Plus Jakarta Sans',sans-serif")))
        )
    }
    if (!rv$triggered) return(empty_plot("Tekan Hitung untuk melihat grafik"))
    v <- vals()
    ops     <- c("Penjumlahan","Pengurangan","Perkalian","Pembagian","Pangkat")
    results <- c(v$plus, v$minus, v$times,
                 ifelse(is.na(v$div), 0, v$div),
                 ifelse(is.na(v$pow), 0, v$pow))
    colors  <- c("#43E97B","#ffd200","#6C63FF","#FF6584","#4facfe")
    
    plot_ly(
      x=ops, y=results, type="bar",
      marker=list(color=colors, opacity=0.88,
                  line=list(color="rgba(0,0,0,0)", width=0)),
      hovertemplate="%{x}: <b>%{y}</b><extra></extra>",
      text=sapply(results, fmt), textposition="outside",
      textfont=list(color="rgba(200,200,220,0.9)",
                    family="'JetBrains Mono',monospace", size=11)
    ) %>%
      layout(
        plot_bgcolor="rgba(0,0,0,0)", paper_bgcolor="rgba(0,0,0,0)",
        font=list(family="'Plus Jakarta Sans',sans-serif",
                  color="rgba(180,180,210,0.75)"),
        xaxis=list(gridcolor="rgba(255,255,255,0.05)", title=""),
        yaxis=list(gridcolor="rgba(255,255,255,0.05)", title="Nilai"),
        margin=list(t=24, b=8),
        bargap=0.35
      ) %>%
      config(displayModeBar=FALSE)
  })
  
  # ── Riwayat ────────────────────────────────────────────────
  output$history_tbl <- renderDT({
    datatable(
      rv$history,
      options=list(pageLength=8, dom="ftipr", ordering=FALSE),
      class="table", rownames=FALSE, style="bootstrap4"
    )
  })
}

shinyApp(ui=ui, server=server)