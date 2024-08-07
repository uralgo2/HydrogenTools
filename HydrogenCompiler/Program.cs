// See https://aka.ms/new-console-template for more information
using System.CommandLine;
using System.CommandLine.Invocation;
using System.Reflection;

class Program
{
    public static async Task<int> Main(params string[] args)
    {
        var rootCommand = new RootCommand(
            description: "Hydrogen compiler.");

        var inputFilesOption = new Option<FileInfo[]>(aliases: new[] { "--input", "-i" }, description: "Files to process.", parseArgument: result =>
        {
            if (result.Tokens.Count == 0)
            {
                result.ErrorMessage = "No input files";
                return null;
            }

            if (result.Tokens.All(token => File.Exists(token.Value)))
            {
                return result.Tokens
                    .Select(token => new FileInfo(token.Value))
                    .ToArray();
            }
            else
            {
                var dontExistFiles = result.Tokens
                    .Where(token => !File.Exists(token.Value))
                    .Select(token => token.Value).ToArray();
                
                result.ErrorMessage = dontExistFiles.Length == 1
                    ? $"File does not exist: {dontExistFiles.First()}"
                    : $"Files does not exists: {string.Join(", ", dontExistFiles)}";
                return null;
            }
        });
        var outputFileOption =
            new Option<FileInfo>(new[] { "--output", "-o" }, () => new FileInfo("program.exe"), "Output file.");
        var onlyTranslateToCOption = new Option<bool>(new[] { "--only-translate" }, () => false, "Output file.");

        var compileCommand = new Command("compile", "Compile all passed files.")
        {
            inputFilesOption,
            outputFileOption,
            onlyTranslateToCOption
        };
        
        compileCommand.SetHandler(Compile, inputFilesOption, outputFileOption, onlyTranslateToCOption);
        rootCommand.AddCommand(compileCommand);

        return await rootCommand.InvokeAsync(args);
    }

    public static void Compile(FileInfo[] input, FileInfo output, bool onlyTranslateToC)
    {
        
    }
}