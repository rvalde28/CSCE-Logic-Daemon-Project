module LogicHelper
    def generate_subsections(chapter_num)
        # Uses preset keys and chapter names for integration with perl (originally how perl does chapter generation as well)
        @keys = []
        @names = []
        
        if(chapter_num == 1)
            @keys = ["Ex1.1", "Ex1.2.1", "Ex1.2.2", "Ex1.2.3", "Ex1.3", "Ex1.4.1", "Ex1.4.2",
                    "Ex1.5.1a", "Ex1.5.1b", "Ex1.5.2", "Ex1.5.4", "Ex1.5.random", "Ex1.6.1"]

            @names = ["Ex. 1.1: Validity and Soundness", 
                        "Ex. 1.2.1: Sentential Wffs (prev. 1.1)",
                        "Ex. 1.2.2: Dropping Parentheses (prev. 1.2a)", 
                        "Ex. 1.2.3: Reading Missing Parentheses (prev. 1.2b)",
                        "Ex. 1.3: Sentential Translations", 
                        "Ex. 1.4.1: Completing Proofs (prev. 1.4)",
                        "Ex. 1.4.2: Simple Proofs", 
                        "Ex. 1.5.1: Basic Conditional and Reduction Proofs",
                        "Ex. 1.5.1: Proofs of Disjunctions", 
                        "Ex. 1.5.2: S40 through S63", 
                        "Ex. 1.5.4: More Proofs",
                        "Ex. 1.5: Random Proof!", 
                        "Ex. 1.6.1: Prove Theorems"]

        elsif(chapter_num == 2)
            @keys = ["Ex2.2", "Ex2.4.2", "Ex2.5.2", "Supp.Ch2"]

            @names = ["Ex. 2.2: Invalidating Assignments", 
                        "Ex. 2.4.2: Indirect TT Method (prev. 2.4b)",
                        "Ex. 2.5.2: More Sequents for ITT Method (prev 2.6)", 
                        "Supplemental T/F Quiz on Semantics"]
	          
        elsif(chapter_num == 3)
            @keys = ["Ex3.1.1", "Ex3.2a", "Ex3.2b", "Ex3.2c", "Ex3.3.2", "Ex3.4.1", "Ex3.4.2"]

            @names = ["Ex. 3.1.1: Wffs of Predicate Logic (prev. 3.1)", 
                        "Ex 3.2s: Simple Translations (supplemental ex.)",
                        "Ex. 3.2: Single-pace Predicate Translations (prev. 3.5)", 
                        "Ex. 3.2: Multi-place Predicate Translations (prev. 3.5)",
                        "Ex. 3.3.2: Predicate Logic Proofs (prev. 3.6)", 
                        "Ex. 3.4.1: More Sequents (prev. 3.7)", 
                        "Ex 3.4.2: Theorems (prev. 3.8)"]
                        
        elsif(chapter_num == 4)
            @keys = ["Ex4.1.1", "Ex4.1.1s", "Ex4.2", "Ex4.3.1"]
            
            @names = ["Ex 4.1.1: Quantifier Expansions w/ Single-place Preds",
                        "Ex 4.1.1s: Expansions w/  Multi-place Preds (suppl. ex.)",
                        "Ex 4.2: Countermodels w/ Single-place Predicates",
                        "Ex 4.3.1: Countermodels w/ Multi-place Predicates"]
        end
        
        @subsections = {}
        (0..@keys.length).each do |i|
            @subsections[@keys[i]] = @names[i]
        end
        
        return @subsections
    end
    
    def expand_universe_question(question)
        @htmlString = "Expand " + question + " <br>"
        
       ["a", "a,b", "a,b,c"].each do  |universe|
           @htmlString += "...for universe {" + universe + "}: <br>"
           @htmlString += "<input type=\"text\" name=\"expansion\" size=\"60\" > <br>"
        end
        
        return @htmlString
    end

end
