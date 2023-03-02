const vscode = require('vscode');

function hello() { vscode.window.showInformationMessage(hello.toString()); }

async function activate(context) {
    console.log(activate, context);
    let disposable = vscode.commands.registerCommand('pmc.hello', hello);
    context.subscriptions.push(disposable);
    vscode.window.showInformationMessage(
        activate.toString() + '\n\n' + context.toString());
}

function deactivate() {
    console.log(deactivate);
    vscode.window.showInformationMessage(deactivate.toString());
}

module.exports = {
    activate,
    deactivate
}
