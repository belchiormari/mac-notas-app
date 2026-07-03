# Notas Rápidas

Um app de notas nativo para macOS, no estilo do Bloco de Notas do Windows:
abre instantaneamente e salva o texto em arquivos `.txt` de verdade no seu
disco (nada de sincronização, banco de dados ou iCloud).

Feito em Swift/SwiftUI puro — sem Electron, sem dependências pesadas — por
isso o app abre quase no mesmo instante em que você clica no ícone.

## Requisitos

- macOS 11 (Big Sur) ou mais recente.
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

- **⌘N** ou o botão "Nova nota" — cria uma nota nova, já salva automaticamente.
- Digite: a nota salva sozinha no disco enquanto você escreve, sem nenhuma
  janela de "salvar como" ou pergunta de local.
- Clique em qualquer nota da lista lateral para abri-la.
- Botão direito numa nota → **Mover para o Lixo** para apagá-la.
- Todas as notas ficam em `~/Documents/Notas Rápidas/`, um arquivo `.txt`
  por nota, nomeado com a data e hora de criação. Você pode abrir essa
  pasta no Finder a qualquer momento e mexer nos arquivos livremente.

**Primeiro acesso à pasta Documentos:** na primeira vez que o app tentar
salvar, o macOS pode mostrar um aviso perguntando se ele pode acessar sua
pasta Documentos — clique em **OK/Permitir**. Isso é uma proteção de
privacidade do sistema, não um erro do app.

## Estrutura do projeto

- `Sources/NotasRapidas/NotasRapidasApp.swift` — ponto de entrada do app.
- `Sources/NotasRapidas/NoteStore.swift` — lista, cria, apaga e recarrega
  as notas a partir dos arquivos `.txt` em `~/Documents/Notas Rápidas/`.
- `Sources/NotasRapidas/ContentView.swift` — lista lateral + área de edição,
  com salvamento automático enquanto você digita.
- `Resources/Info.plist` — metadados do app (nome, versão, versão mínima do macOS).
- `build.sh` — compila e empacota o `.app`.
