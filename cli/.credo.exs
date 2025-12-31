%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: []
      },
      plugins: [],
      requires: [],
      strict: false,
      parse_timeout: 5000,
      color: true,
      checks: %{
        enabled: [
          {Credo.Check.Consistency.TabsOrSpaces, []},
          {Credo.Check.Readability.ModuleDoc, false},
          {Credo.Check.Refactor.Nesting, [max_nesting: 3]},
          {Credo.Check.Warning.IoInspect, []}
        ]
      }
    }
  ]
}
