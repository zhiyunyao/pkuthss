% Zhiyunyao/pkuthss: lite LaTeX template for dissertations at Peking University
% 2024/04/26 v1.9.4-lite
% GitHub:   https://github.com/zhiyunyao/pkuthss/tree/lite
% Overleaf: https://www.overleaf.com/read/wmsmytgjkxfy#c888f2

% Copyright (c) 2008-2009 solvethis
% Copyright (c) 2010-2022,2024 Casper Ti. Vector
% Copyright (c) 2021 Kurapica
% Copyright (c) 2022 iofu728
% Copyright (c) 2024 Zhiyunyao

% This work may be distributed and/or modified under the conditions of the
% LaTeX Project Public License, either version 1.3 of this license or (at
% your option) any later version.
% The latest version of this license is in
%   https://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX version
% 2005/12/01 or later.

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{pkuthss}
[2024/04/26 v1.9.4-lite Peking University dissertation document class]
\RequirePackage{iftex}
\unless\ifXeTeX
    \ClassError{pkuthss}{%
        The only supported compiler of this template is XeLaTeX.
        Please change the compilation configuration to enable XeLaTeX.
    }
\fi
\DeclareOption{GBK}{
    \ClassError{pkuthss}{%
        The only supported file encoding is UTF-8.
        Please remove the GBK option and change the encoding of all files to UTF-8.
    }
}

% eg. `\thss@int@boolopt{spacing}{true}' will expand to:
%   \newif\ifthss@opt@spacing \thss@opt@spacingtrue
%   \DeclareOption{spacing}{\thss@opt@spacingtrue}
%   \DeclareOption{nospacing}{\thss@opt@spacingfalse}
\def\thss@int@boolopt#1#2{
    \expandafter\newif\csname ifthss@opt@#1\endcsname
    \@nameuse{thss@opt@#1#2}
    \DeclareOption{#1}{\@nameuse{thss@opt@#1true}}
    \DeclareOption{no#1}{\@nameuse{thss@opt@#1false}}
}
% Whether to enable `\Uppercase' (works problematically) in heading marks.
\thss@int@boolopt{uppermark}{false}
% Whether to modify fonts according to school regulation.
\thss@int@boolopt{pkufont}{true}
% Whether to modify footnote format according to school regulation.
\thss@int@boolopt{pkufoot}{true}
% Whether to modify spacing according to school regulation.
\thss@int@boolopt{pkuspace}{true}
% Whether to use some common settings for adjusting spacing.
\thss@int@boolopt{spacing}{true}
% Add PDF bookmark for table of contents.
\thss@int@boolopt{pdftoc}{true}
% Whether to enable the `\spacialchap' command.
\thss@int@boolopt{spechap}{true}
% Whether to automatically set up properties for generated PDF from user
% defined document information (author, title, etc.).
\thss@int@boolopt{pdfprop}{true}
% Whether to disable some infractions intended to make the style less ugly.
\thss@int@boolopt{ugly}{false}
% Whether to enable double-blind mode.
\thss@int@boolopt{blind}{false}
% Pass all other options to `ctexbook' document class.
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
% Process all class options now.
\ProcessOptions\relax

% pkuthss is based on ctexbook
\LoadClass{ctexbook}
% Provides support for `key = val' grammar.
\RequirePackage{keyval}
% Graphics support.
\RequirePackage{graphicx}
% Provides utilities for setting up page layout.
\RequirePackage{geometry}
% fancyhdr provides utilities for setting up headers and footers.
\RequirePackage{fancyhdr}
% Provides `\uline' used in `\maketitle' (but do not mess with `\emph').
\RequirePackage[normalem]{ulem}
% Suppresses warnings of font size substitutions.
\RequirePackage{anyfontsize}
% `\AtEndOfClass' used to avoid `PDF destination not defined' with setspace.
\AtEndOfClass{\RequirePackage[bookmarksnumbered,unicode]{hyperref}}

\ifthss@opt@pkufont
    \RequirePackage{amsmath}
    % Use Times New Roman / Arial according to school regulation.
    \ifXeTeX
        \RequirePackage{unicode-math}
        \setmathfont[
            Extension = .otf,
            BoldFont = XITSMath-Bold
        ]{XITSMath-Regular}
        \DeclareSymbolFont{CMlargesymbols}{OMX}{cmex}{m}{n}
        \let\sumop\relax\let\prodop\relax
        \DeclareMathSymbol{\sumop}{\mathop}{CMlargesymbols}{"50}
        \DeclareMathSymbol{\prodop}{\mathop}{CMlargesymbols}{"51}
        \renewcommand{\Box}{\mdlgwhtsquare}
        \newcommand{\checkbox}{\checkmark\hspace{-0.85em}\Box}

        \setmainfont[
            Extension = .otf,
            UprightFont = *-Regular,
            BoldFont = *-Bold,
            ItalicFont = *-Italic,
            BoldItalicFont = *-BoldItalic
        ]{XITS}
        \setsansfont[
            Extension = .otf,
            UprightFont = *-regular,
            BoldFont = *-bold,
            ItalicFont = *-italic,
            BoldItalicFont = *-bolditalic,
            Scale = 0.95
        ]{texgyreheros}
    \else
        \RequirePackage{textcomp, mathptmx, amssymb}
        \RequirePackage[scaled = 0.95]{helvet}
        \newcommand{\checkbox}{\checkmark\hspace{-0.8em}\Box}
    \fi
\else
    % Provides `\Box' for originauth.tex if unicode-math is absent.
    \RequirePackage{amssymb}
    \newcommand{\checkbox}{\checkmark\hspace{-0.8em}\Box}
\fi

\ifthss@opt@pkufoot
    % Circled text, cf. <https://tex.stackexchange.com/questions/7032/>.
    \RequirePackage{tikz}
    \newcommand*{\thss@int@circled}[1]{%
        \scalebox{0.8}{\tikz[baseline = {([yshift = -0.1\ccwd] char.base)}]{
            \node[
                shape = circle, draw = black, minimum size = 1.25\ccwd, inner sep = 0pt
            ] (char) {#1};
        }}%
    }
    % Use circled numbers as footnote symbols. Does not affect title page, but
    % footnote is rarely used in dissertation covers ;)
    \renewcommand*{\thefootnote}{\protect\thss@int@circled{\arabic{footnote}}}
    \renewcommand*{\thempfootnote}{\protect\thss@int@circled{\arabic{mpfootnote}}}
    % Provides utility to modify footnote spacing.
    \RequirePackage{scrextend}
    % Set up footnote spacing: whole paragraph indent 1.5 ccwd, 0.5 ccwd after mark.
    \deffootnote{1.5\ccwd}{0pt}{\thefootnotemark\hspace{0.5\ccwd}}
\fi

\ifthss@opt@pkuspace
    % lineskip / baselineskip = 20 bp / (12 bp * (6 / 5)).
    \linespread{1.39}\selectfont
    % Provides utilities for setting TOC format; `titles' applied to avoid
    % interfering with LaTeX's own title mechanism.
    \RequirePackage[titles]{tocloft}
    \setlength{\cftbeforechapskip}{6bp plus 1bp}
    \setlength{\cftsecindent}{\ccwd}
    \setlength{\cftsubsecindent}{2\ccwd}
    \setlength{\cftsubsubsecindent}{4\ccwd}
    % `caption' modifies font size and separator of captions.  `subcaption'
    % provides functions similar to `subfigure'/`subfig' but does not clash with
    % `tocloft'; it clashes with `subfigure'/`subfig', but the error message will
    % say they cannot be used simultaneously.
    \RequirePackage{caption, subcaption}
    \ifthss@opt@ugly
        \DeclareCaptionFont{capfsize}{\fontsize{11bp}{13.2bp}}
    \else
        \DeclareCaptionFont{capfsize}{\zihao{5}}
    \fi
    \DeclareCaptionLabelSeparator{quad}{\quad}
    \captionsetup{font = capfsize, labelsep = quad}
    \captionsetup[sub]{font = capfsize}
\fi

\ifthss@opt@spacing
    % Make spacing nicer in some situations (eg. footnotes and verbatims).
    \RequirePackage{setspace}
    % Remove superfluous spacing between footnotes.
    \setlength{\footnotesep}{0pt}
    % Lists often appear to be too sparse when items are just one or two lines
    % long. Here we cancel the extra vertical spacing between list items.
    % The list margin is adjusted due to Chinese typesetting traditions.
    \RequirePackage{enumitem}
    \setlist{nolistsep, leftmargin = 1.5\parindent}
\fi

\ifthss@opt@spechap
    % This command is used to start a chapter without numbering, and correctly set
    % up the headers and footers in the chapter.
    \newcommand{\specialchap}[1]{%
        \chapter*{#1}\addcontentsline{toc}{chapter}{#1}
        \markboth{#1}{}\phantomsection%
    }
\fi

\AtBeginDocument{
    % Set up spacing for displayed formulae.
    \setlength{\abovedisplayskip}{\belowdisplayshortskip}
    \setlength{\belowdisplayskip}{\abovedisplayskip}

    \ifthss@opt@pdftoc
        % Add PDF bookmark for table of contents.
        \let\thss@tmp@tableofcontents\tableofcontents
        \renewcommand{\tableofcontents}{%
            \thss@int@pdfmark{\contentsname}{contents}
            \thss@tmp@tableofcontents%
        }
    \fi
}

% eg. `\thss@int@infoitema{ctitle}' will expand to:
%   \def\ctitle#1{\def\@ctitle{#1}}
%   \define@key{thss@info}{ctitle}{\ctitle{#1}}
\def\thss@int@infoitema#1{
    \@namedef{#1}##1{\@namedef{@#1}{##1}}
    \define@key{thss@info}{#1}{\@nameuse{#1}{##1}}
}

% Set up document labels.
\def\label@titlepage{封面}
\def\label@ctitle{题目：}
\def\label@cauthor{姓\hphantom{汉字}名：}
\def\label@studentid{学\hphantom{汉字}号：}
\def\label@school{院\hphantom{汉字}系：}
\def\label@cmajor{专\hphantom{汉字}业：}
\def\label@direction{研究方向：}
\def\label@cmentor{导师姓名：}
\def\label@ckeywords{关键词：}
\def\label@academic{学术学位}
\def\label@technical{专业学位}
\def\label@cabstract{摘要}
\def\label@denotation{主要符号对照表}
\def\label@ementor{Supervised by\ }
\def\label@ekeywords{KEY WORDS:\ }
\def\label@eabstract{ABSTRACT}
\def\label@blindcover{（匿名评阅论文封面）}
\def\label@blinddiscipline{一级学科：}
\def\label@blindmajor{二级学科：}
\def\label@blindid{论文编号：}
\def\label@blindctitle{中文题目：}
\def\label@blindetitle{英文题目：}

% Set up document information entries.
\thss@int@infoitema{cthesisname}
\thss@int@infoitema{thesiscover}
\thss@int@infoitema{ctitlelines}
\thss@int@infoitema{ctitle}
\thss@int@infoitema{cauthor}
\thss@int@infoitema{studentid}
\thss@int@infoitema{cmajor}
\thss@int@infoitema{school}
\thss@int@infoitema{direction}
\thss@int@infoitema{cmentorlines}
\thss@int@infoitema{cmentor}
\thss@int@infoitema{degreetype}
\thss@int@infoitema{date}
\thss@int@infoitema{ckeywords}
\thss@int@infoitema{etitle}
\thss@int@infoitema{eauthor}
\thss@int@infoitema{emajor}
\thss@int@infoitema{ementor}
\thss@int@infoitema{ekeywords}
\thss@int@infoitema{blindid}
\thss@int@infoitema{discipline}

% Set up page layout.
\geometry{a4paper, hmargin = 2.6cm, headheight = 0.5cm, headsep = 0.6cm}
\ifthss@opt@ugly
    \geometry{top = 3.1cm, bottom = 2.5cm, footskip = 0.8cm}
\else
    \geometry{top = 3.0cm, bottom = 3.1cm, footskip = 1.1cm}
\fi

% Set up chapter/section/... captions.
% The `*skip' values are not supposed to be modified by the `ugly' option:
% the actual style of the school's guide and Word template seem to be different
% from the written specification (when applied verbatim in LaTeX), and here the
% actual style is used.
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}
\ctexset{
    chapter = {beforeskip = {0bp}, afterskip = {18bp plus 0.2ex}},
    section =
        {beforeskip = {20bp plus 1ex minus 0.2ex}, afterskip = {5bp plus 0.2ex}},
    subsection =
        {beforeskip = {12bp plus 1ex minus 0.2ex}, afterskip = {5bp plus 0.2ex}},
    subsubsection =
        {beforeskip = {12bp plus 1ex minus 0.2ex}, afterskip = {5bp plus 0.2ex}}
}
\ctexset{
    chapter = {nameformat = {}, titleformat = {}},
    subsubsection = {format = {\zihao{-4}\bfseries}}
}
\ifthss@opt@ugly
    \ctexset{
        chapter = {format = {\zihao{3}\bfseries\centering}},
        section = {format = {\zihao{4}\bfseries}},
        subsection = {format = {\fontsize{13bp}{15.6bp}\selectfont\bfseries}}
    }
\else
    \ctexset{
        chapter = {format = {\zihao{-2}\bfseries\centering}},
        section = {format = {\zihao{-3}\bfseries}},
        subsection = {format = {\zihao{4}\bfseries}}
    }
\fi

% `\MakeUppercase' works problematically.
% eg. it converts `\cite{ctex}' into `\cite{CTEX}'.
% This option can disable `\MakeUppercase' in left/right heading marks.
\ifthss@opt@uppermark
    \def\thss@int@setcase#1{#1}
\else
    % Code copied from fancyhdr's `\nouppercase', with the redefinition of
    % `\uppercase' dropped to avoid disrupting CJKutf8.
    % cf. <https://code.google.com/p/ctex-kit/issues/detail?id=147>.
    \def\thss@int@setcase#1{%
        \let\MakeUppercase\relax%
        \expandafter\let\csname MakeUppercase \endcsname\relax%
        #1%
    }
\fi
% The actual page style setup.
\fancypagestyle{plain}{
    \fancyhf{}\renewcommand*{\headrulewidth}{0.75bp}
    \fancyfoot[C]{\zihao{5}\normalfont{\thepage}}
    \if@twoside
        \fancyhead[CE]{\zihao{5}\normalfont{\@cthesisname}}
        \fancyhead[CO]{\zihao{5}\normalfont\thss@int@setcase{\leftmark}}
    \else
        \fancyhead[C]{\zihao{5}\normalfont\thss@int@setcase{\leftmark}}
    \fi
}
\pagestyle{plain}

% This places a bookmark pointing to somewhere near the page header;
% Result of simple `\chapter{...} \pdfbookmark{...}' does not look nice,
% because the bookmark will point to somewhere below the chapter mark.
\def\thss@int@pdfmark#1#2{%
    \if@openright\cleardoublepage\else\clearpage\fi
    \pdfbookmark[0]{#1}{#2}%
}

% Usage: \thss@int@fillinblank{(number of lines)}{(line width)}{(contents)}
\def\thss@int@fillinblank#1#2#3{%
    \makebox[0pt][l]{\parbox[t]{#2}{\centering{#3}}}\mbox{}%
    \parbox[t]{#2}{%
        \newcount\thss@tmp@linecount
        \thss@tmp@linecount=#1
        \loop\ifnum\thss@tmp@linecount>0
            % Fill specified space with underline on the bottom line. `\underline'
            % draws line on the baseline (not the bottom line), and this is why
            % `\uline' is used here instead.
            \ifnum\thss@tmp@linecount=1
                \uline{\makebox[#2]{}}
            \else
                \uline{\makebox[#2]{}}\\
            \fi
        \advance\thss@tmp@linecount by -1\relax
        \repeat%
    }%
}

\newif\ifnoblind\noblindfalse
% Typeset the title page.
\renewcommand{\maketitle}{%
    \ifthss@opt@blind
        \maketitleblind
    \else
        % Automatically generate properties for generated PDF.
        \newcommand*{\setpdfproperties}{%
            \hypersetup{
                pdfauthor = {\@cauthor}, pdftitle = {\@ctitle},
                pdfsubject = {\@cthesisname}, pdfkeywords = {\@ckeywords}
            }%
        }
        \ifthss@opt@pdfprop
            \setpdfproperties
        \fi
        \maketitlenormal
        \noblindtrue
    \fi
}

% Typeset the title page for normal review.
\newcommand{\maketitlenormal}{%
    \thss@int@pdfmark{\label@titlepage}{titlepage}
    % Make the title page centered.
    \begin{titlepage}\centering
        % Emblem and inscription of the university, and type of thesis.
        {%
            \ifthss@opt@ugly%
            \zihao{-0}\includegraphics[height = 1.9em]{fig/pkulogo.pdf}\hspace{0.3em}%
            \raisebox{0.32em}{\includegraphics[height = 1.3em]{fig/pkuword.pdf}}\\[0.5em]
            \else%
            \zihao{1}\includegraphics[height = 2.4em]{fig/pkulogo.pdf}\hspace{0.4em}%
            \raisebox{0.4em}{\includegraphics[height = 1.6em]{fig/pkuword.pdf}}\\[0.8em]
            \fi%
            {\bfseries\@thesiscover}%
        }
        \vfill
        % Title of the thesis.
        \ifnum\@ctitlelines>0
        {%
            \ifthss@opt@ugly\zihao{-1}\else\zihao{2}\fi%
            \linespread{1.6}\selectfont{\label@ctitle}%
            \thss@int@fillinblank{\@ctitlelines}{0.64\textwidth}{\textbf{\@ctitle}}%
        }\fi
        \vfill
        % Information about the author.
        {%
            % Slightly adjust the line skip when using new font size.
            \zihao{3}\linespread{1.75}\selectfont
            \def\thss@tmp@len{0.56\textwidth}
            \begin{tabular}{l@{\extracolsep{0.2em}}c}
                {\bfseries\label@cauthor}   &
                \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@cauthor}   \\
                {\bfseries\label@studentid} &
                \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@studentid} \\
                {\bfseries\label@school}    &
                \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@school}    \\
                {\bfseries\label@cmajor}    &
                \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@cmajor}    \\
                {\bfseries\label@direction} &
                \thss@int@fillinblank{1}{\thss@tmp@len}{\fangsong\@direction} \\
                {\bfseries\label@cmentor}   &
                \thss@int@fillinblank{\@cmentorlines}%
                {\thss@tmp@len}{\fangsong\@cmentor}                           \\
            \end{tabular}%
        }
        \vfill
        % Degree type.
        \ifnum\@degreetype=1%
            {\zihao{3}\fangsong$\checkbox$ \label@academic\qquad%
            $\Box$ \label@technical}\vfill
        \fi\ifnum\@degreetype=2%
        {\zihao{3}\fangsong$\Box$ \label@academic\qquad%
        $\checkbox$ \label@technical}\vfill
        \fi%
        % Date.
        {\ifthss@opt@ugly\zihao{3}\else\zihao{-2}\fi\@date}
    \par\end{titlepage}%
}

% Typeset the title page for double-blind review.
\newcommand{\maketitleblind}{%
    \thss@int@pdfmark{\label@titlepage}{titlepage}
    \begin{titlepage}
        \centering\zihao{3}\selectfont\fangsong\vspace*{0.5cm}
        {\zihao{-0}\heiti\@cthesisname}\\[0.36\baselineskip]
        {\zihao{-2}\fangsong\label@blindcover}%
        \par\vspace{4\baselineskip}
        \renewcommand{\arraystretch}{1.25}
        \begin{tabular}{lp{0.75\textwidth}}
            \label@blindctitle     & {\raggedright\@ctitle}     \\
            \label@blindetitle     & {\raggedright\@etitle}     \\\\
            \label@blinddiscipline & {\raggedright\@discipline} \\
            \label@blindmajor      & {\raggedright\@cmajor}     \\
            \label@blindid         & {\raggedright\@blindid}    \\
        \end{tabular}\par\vfill
        \ifnum\@degreetype=1%
            $\checkbox$ \label@academic\qquad$\Box$ \label@technical%
        \fi\ifnum\@degreetype=2%
            $\Box$ \label@academic\qquad$\checkbox$ \label@technical%
        \fi\par\vfill
        {\@date}\par\vspace*{0.5cm}
    \end{titlepage}%
}

% Typeset the Chinese abstract.
\newenvironment{cabstract}{%
    \thss@int@pdfmark{\label@cabstract}{cabstract}
    \chapter*{\label@cabstract}\markboth{\label@cabstract}{}%
}{% Keywords at the bottom of the page.
    \vfill\noindent\label@ckeywords{\@ckeywords}%
}

% Typeset the English abstract.
\newenvironment{eabstract}{%
    \thss@int@pdfmark{\label@eabstract}{eabstract}
    \chapter*{\sffamily\@etitle}\markboth{\label@eabstract}{}
    \begin{center}
        \unless\ifthss@opt@blind
            {\@eauthor} ({\@emajor})\\
            {\label@ementor}{\@ementor}\\[2em]
        \fi
        \textbf{\sffamily\label@eabstract}
    \end{center}\par%
}{% Keywords at the bottom of the page.
    \vfill\noindent\label@ekeywords{\@ekeywords}%
}

% Typeset the item of denotation.
\newlist{thss@denotation}{description}{1}
\setlist[thss@denotation]{%
    nosep,
    font=\normalfont,
    align=left,
    leftmargin=!, % sum of the following 3 lengths
    labelindent=0pt,
    labelwidth=5.5cm,
    labelsep*=0.5cm,
    itemindent=0pt,
}

% Typeset the denotation.
\newenvironment{denotation}[1][5.5cm]{%
    \thss@int@pdfmark{\label@denotation}{denotation}
    \chapter*{\label@denotation}\markboth{\label@denotation}{}%
    \vskip-30bp\zihao{-4}\begin{thss@denotation}[labelwidth=#1]
}{%
    \end{thss@denotation}
}

\endinput
