# Notas Rápidas

Um app de notas nativo para macOS, no estilo do Bloco de Notas do Windows:
abre instantaneamente e salva o texto em arquivos `.txt` de verdade no seu
disco (nada de sincronização, banco de dados ou iCloud).

Feito em Swift/SwiftUI puro — sem Electron, sem dependências pesadas — por
isso o app abre quase no mesmo instante em que você clica no ícone.

## Requisitos

- macOS 12 ou mais recente.
- Xcode **Command Line Tools** (não precisa do Xcode completo):
  ```bash
  xcode-select --install
  ```

## Como compilar e instalar

```bash
git clone <este repositório>
cd mac-notas-app
./build.sh
```

Isso gera `dist/Notas Rápidas.app`. Para instalar, arraste-o para a pasta
Aplicativos:

```bash
mv "dist/Notas Rápidas.app" /Applications/
```

**Primeira abertura:** como o app é assinado apenas localmente (ad-hoc, sem
conta de desenvolvedor Apple), o Gatekeeper vai bloquear o duplo-clique na
primeira vez. Basta clicar com o botão direito no app → **Abrir** → **Abrir**
na caixa de confirmação. Depois disso, ele abre normalmente com duplo-clique.

### Alternativa: rodar direto pelo Xcode

Se preferir, abra a pasta do projeto (`Package.swift`) no Xcode e aperte
Cmd+R. Ótimo para testar rapidamente, mas o `build.sh` é o caminho para ter
um app de verdade instalado em Aplicativos/Dock.

## Uso

- **⌘N** — nova nota
- **⌘O** — abrir um arquivo `.txt`
- **⌘S** — salvar
- **⌘W** — fechar a janela
- Segure **⌥ Option** ao abrir o menu **Arquivo** para ver "Salvar Como..."
  (no macOS moderno isso substitui o antigo "Save As", igual no TextEdit)
- Cada nota é uma janela independente, exatamente como no Bloco de Notas —
  pode abrir várias ao mesmo tempo.
- Ao fechar uma janela com alterações não salvas, o macOS pergunta se você
  quer salvar (comportamento nativo, sem código extra).

## Estrutura do projeto

- `Sources/NotasRapidas/NotasRapidasApp.swift` — ponto de entrada do app.
- `Sources/NotasRapidas/TextDocument.swift` — leitura/escrita do arquivo `.txt`.
- `Sources/NotasRapidas/ContentView.swift` — a área de edição de texto.
- `Resources/Info.plist` — metadados do app (nome, ícone, tipos de arquivo).
- `build.sh` — compila e empacota o `.app`.
